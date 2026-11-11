#!/usr/bin/env python3
"""Markdown Reply Format Checker (Sanitized Public Edition)

A generic format validator for AI assistant reply drafts.
Checks structural rules that can be customized via constants at the top.

Usage:
  python3 check_reply_format.py draft.md
  cat draft.md | python3 check_reply_format.py

Customize EXPECTED_WORD_COUNT, GLOSS_COLOR, ACCENT_COLOR, FOOTER_PATTERN
to match your own reply format specification.

Exit code: 0 = all pass; 1 = any failure
"""
import argparse
import re
import sys

# ─── Configurable constants ──────────────────────────────────────────
EXPECTED_WORD_COUNT = 5

# Highlighted word span: <span style="color:#XXXX"><strong>word</strong></span>
GLOSS_COLOR = r"#[0-9a-fA-F]{6}"          # any hex color
ACCENT_COLOR = r"#[0-9a-fA-F]{6}"          # any hex color

# Footer pattern (last line after code block) — customize to your needs
# Example: <span style="color:#XXXX"><strong>PRICE: 1234</strong></span>
FOOTER_PATTERN = (
    r'<span\s+style=(?:"color:%s"|color:%s)\s*>'
    r'<strong>[A-Z]+:\s*\d+</strong></span>'
) % (ACCENT_COLOR, ACCENT_COLOR)

# Emoji detection range
EMOJI = re.compile("[" "\U0001F300-\U0001FAFF" "\u2600-\u27BF" "\uFE0F" "]")

# ─── Compiled patterns ───────────────────────────────────────────────
SPAN = re.compile(
    r'<span\s+style=(?:"color:%s"|color:%s)\s*>'
    r'<strong>(.*?)</strong></span>' % (GLOSS_COLOR, GLOSS_COLOR)
)

RED = re.compile(FOOTER_PATTERN)


def run_checks(text: str):
    """Run all format checks on the given text. Returns (checks, ok)."""
    checks, ok = [], True

    body, sep, tail = text.rpartition("\n---\n")

    # ── Check 1: Highlighted word count ──
    words = SPAN.findall(body)
    eng_only = all(
        re.fullmatch(r"[A-Za-z][A-Za-z'\-]*", w or "") for w in words
    )
    checks.append((
        "Highlighted word count = %d/%d" % (len(words), EXPECTED_WORD_COUNT),
        len(words) == EXPECTED_WORD_COUNT,
    ))
    checks.append(("All highlighted content is pure English", eng_only))
    ok &= len(words) == EXPECTED_WORD_COUNT and eng_only

    # ── Check 2: Each highlighted word followed by (glossary) ──
    glosses, gloss_bad = {}, []
    for m in SPAN.finditer(body):
        pos = m.end()
        rest = body[pos:pos + 200]
        # Allow optional link: [span](url)
        lm = re.match(r"\]\((?:[^)]+)\)", rest)
        if lm:
            rest = rest[lm.end():]
        gm = re.match(r"（([^）]{1,30})）", rest)
        if gm:
            glosses[m.group(1).lower()] = gm.group(1).strip()
        else:
            gloss_bad.append(m.group(1))
    checks.append((
        "Glossary after each word = %d/%d" % (len(glosses), EXPECTED_WORD_COUNT),
        not gloss_bad and len(glosses) == EXPECTED_WORD_COUNT,
    ))
    if gloss_bad:
        checks.append(("Missing glossary: %s" % ", ".join(gloss_bad), False))
    ok &= not gloss_bad and len(glosses) == EXPECTED_WORD_COUNT

    # ── Check 3: No full-width quotes in style attributes ──
    curly = re.search(r'style=[^<>]{0,24}[\u201c\u201d]', text)
    checks.append(("No full-width quotes in style attributes", not curly))
    ok &= not curly

    # ── Check 4: No <mark> tags ──
    mark_free = "<mark>" not in text
    checks.append(("No <mark> tags", mark_free))
    ok &= mark_free

    # ── Check 5: Separator line exists ──
    checks.append(("Separator line (---) exists", bool(sep)))
    ok &= bool(sep)

    # ── Check 6: Code block after separator ──
    block = re.search(r"```(?:.*?)\n(.*?)```", tail, re.S) if tail else None
    checks.append(("Code block after separator", bool(block)))
    ok &= bool(block)

    if block:
        lines = [l.strip() for l in block.group(1).splitlines() if l.strip()]

        # ── Check 7: Glossary line count matches word count ──
        checks.append((
            "Glossary lines = %d/%d" % (len(lines), len(words)),
            len(lines) == len(words),
        ))

        # ── Check 8: Words in block match words in body ──
        same = [l.split(" — ")[0].strip().lower() for l in lines]
        match = sorted(w.lower() for w in words) == sorted(same)
        checks.append(("Block words match body words (%s)" % ", ".join(same), match))

        # ── Check 9: Inline glossary consistent with footnote ──
        pairs = {}
        for l in lines:
            if " — " in l:
                w, d = l.split(" — ", 1)
                pairs[w.strip().lower()] = d.strip()

        def consistent(w):
            g, d = glosses.get(w), pairs.get(w)
            if not g or not d:
                return False
            return d == g or d.startswith(g)

        mism = [
            "%s: body「%s」!= footnote「%s」" % (w, glosses.get(w, "N/A"), pairs.get(w, "N/A"))
            for w in glosses if not consistent(w)
        ]
        checks.append(("Inline glossary matches footnote", not mism))
        if mism:
            checks.append(("Mismatch detail (%s)" % "; ".join(mism), False))

        # ── Check 10: Footer line after code block ──
        after = [l.strip() for l in tail[block.end():].splitlines() if l.strip()]
        last = after[-1] if after else ""
        red_out = bool(RED.fullmatch(last)) and len(after) == 1
        checks.append(("Single footer line at end", red_out))

        ok &= len(lines) == len(words) and match and red_out and not mism
    else:
        checks.append(("Footer check (no code block)", False))
        ok = False

    # ── Check 11: No emoji ──
    emo = EMOJI.findall(text)
    checks.append(("No emoji (found %d)" % len(emo), not emo))
    ok &= not emo

    return checks, ok


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Markdown reply format checker (sanitized public edition)"
    )
    ap.add_argument("draft", nargs="?", help="path to draft markdown file")
    a = ap.parse_args()

    path = a.draft
    text = open(path, encoding="utf-8").read() if path else sys.stdin.read()

    checks, ok = run_checks(text)

    print("Reply Format Check")
    for name, passed in checks:
        print("  %s %s" % ("PASS" if passed else "FAIL", name))
    print("Result: %s (%d/%d)" % (
        "PASS" if ok else "FAIL",
        sum(p for _, p in checks),
        len(checks),
    ))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
