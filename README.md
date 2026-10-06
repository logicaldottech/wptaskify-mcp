# wptaskify MCP server

wptaskify is a hosted [Model Context Protocol](https://modelcontextprotocol.io) server that lets Claude, ChatGPT, Cursor or any MCP client do real work on WordPress sites, WooCommerce and Shopify stores, Pinterest accounts and Google Search Console. Risky actions (deletes, refunds, theme switches and similar) wait for a person to approve them.

Nothing to install or host: you add a URL to your AI client and sign in.

- Website: https://wptaskify.com
- Developer docs: https://wptaskify.com/developers
- Tool reference (every tool and its parameters): https://wptaskify.com/developers/tools
- Machine-readable tool list: https://wptaskify.com/developers/tools.json
- Official MCP Registry: `com.wptaskify/wordpress` and `com.wptaskify/store`

This repository holds the public metadata, client configs and examples. The server itself is a hosted service.

## Endpoints

| URL | Use it for |
|---|---|
| `https://wptaskify.com/mcp` | WordPress sites, Elementor, Pinterest, Google Search Console and Analytics |
| `https://wptaskify.com/mcp/store` | WooCommerce and Shopify stores |

Both speak MCP over Streamable HTTP (JSON-RPC 2.0).

## Connect

**Claude Code**

```bash
claude mcp add --transport http wptaskify https://wptaskify.com/mcp
```

**Cursor** (`~/.cursor/mcp.json`)

```json
{
  "mcpServers": {
    "wptaskify": { "url": "https://wptaskify.com/mcp" }
  }
}
```

**VS Code** (`.vscode/mcp.json`)

```json
{
  "servers": {
    "wptaskify": { "type": "http", "url": "https://wptaskify.com/mcp" }
  }
}
```

**Clients that only run local (stdio) servers**

```json
{
  "mcpServers": {
    "wptaskify": { "command": "npx", "args": ["-y", "mcp-remote", "https://wptaskify.com/mcp"] }
  }
}
```

**Claude.ai and ChatGPT** connect from their own settings: see https://wptaskify.com/docs/claude and https://wptaskify.com/docs/chatgpt.

Add `https://wptaskify.com/mcp/store` as a second connector if you also want the store tools.

## Authentication

OAuth 2.1: authorization code with PKCE (S256), public clients and dynamic client registration. Most MCP clients handle this the first time they connect.

- Discovery: `https://wptaskify.com/.well-known/oauth-authorization-server` and `https://wptaskify.com/.well-known/oauth-protected-resource`
- A request without a token returns `401` with `WWW-Authenticate: Bearer resource_metadata=...`
- There are no static API keys. Use `mcp-remote` for clients that cannot do OAuth themselves.

## What the tools cover

- **WordPress:** posts and pages, SEO and AEO fields, schema, internal links, media and alt text, menus, users, themes and plugins, backups and site health
- **Elementor:** read and edit page layouts
- **WooCommerce:** products, variations, categories, coupons, orders and refunds
- **Shopify:** products, collections, pages, articles, discounts, redirects, metafields and theme files
- **Pinterest:** drafts, boards and sections, scheduling with safe gaps, pin and account analytics
- **Google:** Search Console and Analytics reports

The full, current list with parameters is at https://wptaskify.com/developers/tools. Your wptaskify plan decides which tools run for you.

## Approvals

A risky tool does not run straight away. It returns:

```json
{
  "needs_approval": true,
  "approval_id": "a1b2c3",
  "action": "Permanently delete post 42",
  "next": "Ask the user to approve, call resolve_approval with this approval_id, then call the same tool again with the same arguments."
}
```

The person approves in chat or in the wptaskify dashboard; then the same call goes through.

## Examples

See [`examples/`](examples) for raw JSON-RPC calls and sample prompts.

## Links

- Pricing: https://wptaskify.com/pricing
- Security: https://wptaskify.com/security
- Prompt library: https://wptaskify.com/prompts
- WordPress plugin: https://wordpress.org/plugins/wptaskify-search-signal-for-mcp/

Built by Logical Dottech.
