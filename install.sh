#!/usr/bin/env zsh
# shellcheck disable=SC2016

source <(kubectl completion zsh)
alias k=kubecolor
compdef kubecolor=kubectl
alias profile="aws-sso|egrep 'dev|test|prod'|grep -i admin|grep -v qs-admin|sort -k3,3"
alias eks="kubectl config get-contexts|awk '{print \$2}'|egrep 'development|test|production'"
alias k8s="/home/vscode/dotfiles/k8s_switch.sh"
alias sso="/home/vscode/dotfiles/sso_switch.sh"

setopt PROMPT_SUBST

_build_prompt() {
  local prompt=""
  if [ "$(git config --get devcontainers-theme.hide-status 2>/dev/null)" != 1 ] && [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then
    local BRANCH=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ "${BRANCH}" != "" ]; then
      prompt+="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}${BRANCH}"
      if [ "$(git config --get devcontainers-theme.show-dirty 2>/dev/null)" = 1 ] && git --no-optional-locks ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then
        prompt+=" %{$fg_bold[yellow]%}✗"
      fi
      prompt+="%{$fg_bold[cyan]%})%{$reset_color%} "
    fi
  fi

  local CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null)
  local CURRENT_NAMESPACE=$(kubectl config view --minify --output "jsonpath={..namespace}" 2>/dev/null)
  local colour=white
  case ${CURRENT_CONTEXT} in
    *"development"*|*"sandbox"*) colour=green ;;
    *"test"*)                    colour=blue ;;
    *"preproduction"*)           colour=yellow ;;
    *"production"*)              colour=red ;;
    *)                           colour=white ;;
  esac


local CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null | awk -F'/' '{print $NF}'|sed -e 's/analytical-platform-//g' -e 's/development/dev/g')
  
[[ -n ${CURRENT_CONTEXT} ]]   && prompt+="[%{$fg[$colour]%}${CURRENT_CONTEXT}%{$reset_color%}]"
  [[ -n ${CURRENT_NAMESPACE} ]] && prompt+="[${CURRENT_NAMESPACE}]"

  if [[ -n ${AWS_SSO_PROFILE} ]]; then
    local aws_colour=white
    case ${AWS_SSO_PROFILE} in
      *"development"*|*"sandbox"*) aws_colour=green ;;
      *"test"*)                    aws_colour=blue ;;
      *"preproduction"*)           aws_colour=yellow ;;
      *"production"*)              aws_colour=red ;;
    esac
    local AWS_ROLE=$(echo "${AWS_SSO_PROFILE}" | awk -F'/' '{print $NF}' | sed \
      -e 's/analytical-platform-//g' \
      -e 's/data-engineering/data-eng/g' \
      -e 's/next-poc-producer/poc-prod/g' \
      -e 's/-sandbox-a/-sbox-a/g' \
      -e 's/production/prod/g' \
      -e 's/development/dev/g' \
      -e 's/AdministratorAccess/Admin/g' \
      -e 's/modernisation-platform-//g' \
      -e 's/platform-engineer-//g' \
      -e 's/ingestion/ingest/g')
    prompt+="[%{$fg[$aws_colour]%}${AWS_ROLE}%{$reset_color%}]"
  fi

  echo -n "${prompt} "
}

PROMPT='$(_build_prompt)'
