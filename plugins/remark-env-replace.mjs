import { visit } from 'unist-util-visit';

function getReplacements() {
  return {
    '{{CONTACT_EMAIL}}': process.env.PUBLIC_CONTACT_EMAIL || 'hello@lawh.app',
    '{{SITE_URL}}': (process.env.SITE_URL || 'https://lawh.bcube.tech').replace(/\/$/, ''),
  };
}

function replaceTokens(str, replacements) {
  let result = str;
  for (const [token, value] of Object.entries(replacements)) {
    result = result.replaceAll(token, value);
  }
  return result;
}

export default function remarkEnvReplace() {
  return (tree) => {
    const replacements = getReplacements();

    visit(tree, 'text', (node) => {
      node.value = replaceTokens(node.value, replacements);
    });

    visit(tree, 'link', (node) => {
      node.url = replaceTokens(node.url, replacements);
    });
  };
}
