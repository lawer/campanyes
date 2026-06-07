#!/usr/bin/env python3
from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent
INCLUDE_RE = re.compile(r"^\{\{\s*include:([^}]+)\s*\}\}\s*$", re.MULTILINE)


def expand_includes(text: str, seen: tuple[Path, ...] = ()) -> str:
    def replace(match: re.Match[str]) -> str:
        rel = match.group(1).strip()
        path = (ROOT / rel).resolve()
        if ROOT not in path.parents and path != ROOT:
            raise SystemExit(f"Include fora del projecte: {rel}")
        if path in seen:
            chain = " -> ".join(str(p.relative_to(ROOT)) for p in (*seen, path))
            raise SystemExit(f"Include circular: {chain}")
        if not path.exists():
            raise SystemExit(f"Include no trobat: {rel}")
        return expand_includes(path.read_text(encoding="utf-8"), (*seen, path)).rstrip()

    return INCLUDE_RE.sub(replace, text)


def expand_file(src_rel: str, dst_rel: str) -> None:
    src = ROOT / src_rel
    dst = ROOT / dst_rel
    dst.parent.mkdir(exist_ok=True)
    dst.write_text(expand_includes(src.read_text(encoding="utf-8")), encoding="utf-8")
    print(dst.relative_to(ROOT))


def main() -> int:
    expand_file("index.md", ".build/index.expanded.md")
    expand_file("campaigns/lluna-mossegada/campanya.md", ".build/lluna-mossegada.expanded.md")
    expand_file("campaigns/stranger-things/campanya.md", ".build/stranger-things.expanded.md")
    expand_file("campaigns/ombres-sant-josep/campanya.md", ".build/ombres-sant-josep.expanded.md")
    expand_file("campaigns/stranger-pulp/campanya.md", ".build/stranger-pulp.expanded.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
