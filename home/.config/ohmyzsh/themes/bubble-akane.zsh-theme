# Akane prompt colors.
local active="#e55454"
local success="#f4c27a"
local destructive="#e55454"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{$success}  "
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{$destructive}●%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Clean minimal prompt: directory + git + $.
PROMPT='%F{$active}%2~%f$(git_prompt_info) %F{$active}$%f '
