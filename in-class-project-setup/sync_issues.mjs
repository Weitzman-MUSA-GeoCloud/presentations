/*
  Given a GitHub organization, a term, and the number of teams, this script
  will initialize the repository with issues from the issues/to-upload/ folder,
  and attach those issues to the project.
*/

// =============================================================================
// Update the following variables to match your course
const GITHUB_OWNER = 'Weitzman-MUSA-GeoCloud';
const TERM = 's26';  // e.g. 's26' for Spring 2026, 'f26' for Fall 2026, etc.
const NUM_TEAMS = 7;
// =============================================================================

import { Octokit } from "@octokit/rest";
import { createTokenAuth } from "@octokit/auth-token";
import { RequestError } from "@octokit/request-error";
import fs from "fs/promises";
import matter from "gray-matter";
import { parse } from 'yaml';
import { config } from '@dotenvx/dotenvx';
import Mustache from 'mustache';

config();

const auth = createTokenAuth(process.env.GITHUB_TOKEN);
const { token } = await auth()
const octokit = new Octokit({ auth: token });

// Read the file in issues/to-upload/issue-slugs.yml
const issues = await fs.readFile('issues/to-upload/issue-slugs.yaml', 'utf-8');
const issueSlugs = parse(issues).issues;

// For each issue, read the file in issues/to-upload/{issueSlug}.md; parse the
// front matter, and create the issue in the specified repository.
for (let teamNumber = 1; teamNumber <= NUM_TEAMS; ++teamNumber) {
  const repo = `${TERM}-team${teamNumber}-cama`;
  const variables = {
    gcp_project: `musa5090${TERM}-team${teamNumber}`,
  };

  for (const [issueIndex, issueSlug] of Object.entries(issueSlugs)) {
    const issue = await fs.readFile(`issues/to-upload/${issueSlug}.md`, 'utf-8');
    const issueNumber = parseInt(issueIndex) + 1;
    const { data: frontMatter, content } = matter(issue);

    const body = Mustache.render(content, variables);
    const { title, labels } = frontMatter;
    await updateIssue(GITHUB_OWNER, repo, issueNumber, title, body, labels);

    // Wait 3 seconds between requests to avoid rate limiting
    await new Promise(resolve => setTimeout(resolve, 3000));
  }
}

async function updateIssue(owner, repo, issue_number, title, body, labels) {
  console.log(`Syncing issue ${issue_number} in ${owner}/${repo}`);
  try {
    await octokit.request('PATCH /repos/{owner}/{repo}/issues/{issue_number}', {
      owner: owner,
      repo: repo,
      issue_number: issue_number,
      title: title,
      body: body,
      labels: labels,
      headers: {
        'X-GitHub-Api-Version': '2022-11-28'
      }
    })
  } catch (error) {
    if (error instanceof RequestError && error.status === 404) {
      await octokit.request('POST /repos/{owner}/{repo}/issues', {
        owner: owner,
        repo: repo,
        title: title,
        body: body,
        labels: labels,
        headers: {
          'X-GitHub-Api-Version': '2022-11-28'
        }
      })
    } else {
      throw error
    }
  }
}
