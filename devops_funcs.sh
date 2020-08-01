# @param 1 - authorizatio data, currently basic loginemail:password
# @param 2 - project key in Bitbucket
# @param 3 - workspace, i.e. user name
# @param 4 - repository name
# reference: https://developer.atlassian.com/bitbucket/api/2/reference/resource/repositories/%7Bworkspace%7D/%7Brepo_slug%7D#post
function create_repo_in_bitbucket {
  _auth_data=${1}
  _project_key=${2}
  _workspace=${3}
  _repo=${4}
  curl --user ${_auth_data} -X POST -H "Content-Type: application/json" -d '{
    "scm": "git",
    "project": {
        "key": "'${_project_key}'"
    }
  }' https://api.bitbucket.org/2.0/repositories/${_workspace}/${_repo}
}
