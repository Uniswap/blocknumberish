import { defineConfig } from 'vocs/config'
import { sidebar } from './vocs.sidebar'

export default defineConfig({
  title: "Documentation",
  editLink: { pattern: 'https://github.com/Uniswap/blocknumberish/edit/ci/bump-bullfrog-0.11.1/{path}' },
  codeHighlight: {
    fallbackLanguage: 'plaintext',
    langs: [
      'ansi', 'bash', 'diff', 'html', 'js', 'json', 'jsx',
      'markdown', 'md', 'mdx', 'plaintext', 'rust', 'sol', 'solidity',
      'toml', 'ts', 'tsx', 'yaml', 'zsh',
    ],
  },
  sidebar,
})
