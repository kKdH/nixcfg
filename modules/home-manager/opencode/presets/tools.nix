{
  github = {
    # context
    "github_get_me" = true;
    # issues
    "github_issue_*" = true; # issue_read, issue_write
    "github_list_issues" = true;
    "github_list_issue_*" = true; # list_issue_types, list_issue_fields
    "github_search_issues" = true;
    "github_add_issue_comment" = true;
    "github_update_issue_comment" = true;
    "github_sub_issue_write" = true;
    # labels
    "github_get_label" = true;
    "github_list_label" = true;
    "github_label_write" = true;
    # pull requests
    "github_create_pull_request" = true;
    "github_list_pull_requests" = true;
    "github_search_pull_requests" = true;
    "github_update_pull_request" = true;
    "github_update_pull_request_branch" = true;
    "github_merge_pull_request" = true;
    "github_pull_request_*" = true; # pull_request_read, pull_request_review_write
    "github_add_comment_to_pending_review" = true;
    "github_add_reply_to_pull_request_comment" = true;
    # actions
    "github_actions_*" = true; # actions_get, actions_list, actions_run_trigger
    "github_get_job_logs" = true;
  };
}
