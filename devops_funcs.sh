# @param 1 - authorization data, currently basic loginemail:password
# @param 2 - project key in Bitbucket. In Bitbucket, project is the parent of multiple repositories. This can be learnt through the web GUI with web browser
# @param 3 - workspace, i.e. user name. For instance, my user name is rxue911
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
# @param 1 - git address, e.g. git@bitbucket.org:rxue911/project-generator.git
function sync_git_repo {
  _git_address=${1}
  git clone ${_git_address}
  _repository_name=$(python3 -c "print('${_git_address}'.split('/')[-1][:-4])")
  echo "repository name is ${_repository_name}"
  cd ${_repository_name}
  touch README.md
  git add README.md
  git commit -m "first commit"
  git push origin master
}
