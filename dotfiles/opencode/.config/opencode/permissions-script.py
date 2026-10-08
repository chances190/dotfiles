#!/usr/bin/env python3
"""Parse permissions-reference.md and generate per-agent V2 shell permission rules.

Output: per-agent YAML files with V2 permissions array entries.
Can also generate full agent frontmatter blocks (with --frontmatter flag).
"""

def parse_reference(path):
    """Parse the Rules Matrix table from permissions-reference.md."""
    with open(path) as f:
        content = f.read()

    table_start = content.find("| Command (glob)")
    table_end = content.find("\n\n", table_start)
    if table_end == -1:
        table_end = len(content)
    table_section = content[table_start:table_end]

    rules = []
    for line in table_section.strip().split("\n"):
        if line.startswith("|---") or line.startswith("| Command"):
            continue
        if not line.strip():
            continue

        cols = [c.strip() for c in line.split("|")]
        cols = cols[1:-1]
        if len(cols) < 3:
            continue

        glob = cols[0].strip().strip('`')
        cls = cols[1].strip()

        if "git-safe" in cls:
            cls = "destructive-git-safe"
        elif "destructive" in cls:
            cls = "destructive"

        rules.append((glob, cls))

    return rules

def generate_agent_permissions(rules, class_policies):
    """Generate V2 permissions array entries for a specific agent."""
    by_class = {}
    for glob, cls in rules:
        by_class.setdefault(cls, []).append(glob)

    lines = []
    for cls, policy in class_policies.items():
        if cls in by_class:
            for glob in by_class[cls]:
                lines.append(f'  - {{ "action": "shell", "resource": "{glob}", "effect": "{policy}" }}')

    return "\n".join(lines)


def main():
    ref_path = "/home/chances/arch-setup/dotfiles/opencode/.config/opencode/permissions-reference.md"
    rules = parse_reference(ref_path)

    agents = {
        "ask": {
            "read-only": "allow",
            "mutation": "deny",
            "destructive-git-safe": "deny",
            "destructive": "deny",
        },
        "adhoc": {
            "read-only": "allow",
            "mutation": "allow",
            "destructive-git-safe": "ask",
            "destructive": "ask",
        },
        "coder": {
            "read-only": "allow",
            "mutation": "allow",
            "destructive-git-safe": "allow",
            "destructive": "ask",
        },
        "architect": {
            "read-only": "allow",
            "mutation": "ask",
            "destructive-git-safe": "deny",
            "destructive": "deny",
        },
    }

    output_dir = "/home/chances/arch-setup/dotfiles/opencode/.config/opencode/agents"

    for agent_name, policies in agents.items():
        perm_lines = generate_agent_permissions(rules, policies)
        filename = f"{agent_name}-rules.yaml"
        filepath = f"{output_dir}/{filename}"

        with open(filepath, "w") as f:
            f.write(f"# V2 shell permission rules for {agent_name}\n")
            f.write(f"# Generated from permissions-reference.md\n")
            f.write(f"# Copy relevant lines into agent frontmatter under permissions:\n\n")
            f.write("permissions:\n")
            f.write(perm_lines + "\n")
            # MCP tools
            f.write("\n  # MCP tools\n")
            f.write('  - { "action": "_", "resource": "context7_*", "effect": "allow" }\n')
            f.write('  - { "action": "_", "resource": "shadcn_*", "effect": "allow" }\n')

        print(f"Generated: {filepath}")

if __name__ == "__main__":
    main()
