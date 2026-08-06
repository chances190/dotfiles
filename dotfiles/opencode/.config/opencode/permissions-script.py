#!/usr/bin/env python3
"""Parse permissions-reference.md and generate per-agent YAML bash rules."""

def parse_reference(path):
    """Parse the Rules Matrix table from permissions-reference.md."""
    with open(path) as f:
        content = f.read()

    table_start = content.find("| Command (glob)")
    table_end = content.find("\n\n", table_start)
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
        rtk = cols[1].strip()
        cls = cols[2].strip()

        if "git-safe" in cls:
            cls = "destructive-git-safe"
        elif "destructive" in cls:
            cls = "destructive"

        if rtk in ("y", "p"):
            glob = f"rtk {glob}"

        rules.append((glob, cls))

    return rules

def generate_agent_yaml(rules, class_policies):
    """Generate bash permission YAML for a specific agent."""
    by_class = {}
    for glob, cls in rules:
        by_class.setdefault(cls, []).append(glob)

    all_rules = []
    for cls, policy in class_policies.items():
        if cls in by_class:
            for glob in by_class[cls]:
                all_rules.append((glob, policy))

    lines = []
    for glob, policy in all_rules:
        lines.append(f'    "{glob}": "{policy}"')

    return "bash:\n" + "\n".join(lines)

def main():
    ref_path = "/home/chances/arch-setup/dotfiles/opencode/permissions-reference.md"
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
        yaml_content = generate_agent_yaml(rules, policies)
        filename = f"{agent_name}-rules.yaml"
        filepath = f"{output_dir}/{filename}"

        with open(filepath, "w") as f:
            f.write(yaml_content + "\n")

        print(f"Generated: {filepath}")

if __name__ == "__main__":
    main()
