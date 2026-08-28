# Workflow

```
terminal → herdr → container / worktree → Pi
```

Herdr owns host PTYs and agent panes. Agents run inside a container or a task worktree, not as the Herdr process. Do not nest tmux around an agent pane Herdr is supposed to detect.

This kit holds the reins (skills, Pi fragments, Herdr recipes). Each machine keeps its own hitch.
