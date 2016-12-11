setopt prompt_subst

FOUND_KUBECTL=0
if which kubectl >/dev/null 2>&1; then
    FOUND_KUBECTL=1
fi

function kubernetes_current_context() {
    local context="$(kubectl config current-context)"
    [ $? -eq 0 ] && echo "$context" || echo "no context"
}

function kubernetes_current_cluster() {
    local line="$(kubectl config get-contexts --no-headers | grep -e '^*')"
    [ $? -eq 0 ] && echo "$line" | awk '{print $3}' || echo "no context"
}

function kubernetes_current_user() {
    local line="$(kubectl config get-contexts --no-headers | grep -e '^*')"
    [ $? -eq 0 ] && echo "$line" | awk '{print $4}' || echo "no context"
}

function kubernetes_current_namespace() {
    local line="$(kubectl config get-contexts --no-headers | grep -e '^*')"
    [ $? -eq 0 ] && echo "$line" | awk '{if($5!=NULL){print $5}else{print "default"}}' || echo "no context"
}

# cluster/namespace
function kubernetes_prompt_info() {
    local line="$(kubectl config get-contexts --no-headers | grep -e '^*')"
    [ $? -eq 0 ] && echo "$line" | awk '{printf $3"/";if($5!=NULL){print $5}else{print "default"}}' || echo "no context"
}

if [ $FOUND_KUBECTL -eq 0 ]; then
    function kubernetes_current_context() { echo "Could not find kubectl" }
    function kubernetes_current_cluster() { echo "Could not find kubectl" }
    function kubernetes_current_user() { echo "Could not find kubectl" }
    function kubernetes_current_namespace() { echo "Could not find kubectl" }
    function kubernetes_prompt_info() { echo "Could not find kubectl" }
fi
