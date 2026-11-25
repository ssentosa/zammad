# Fork customizations

This fork (`origin` = github.com/ssentosa/zammad) carries a small set of changes on top of
upstream Zammad (`upstream` = github.com/zammad/zammad). This file lists every one of
them, so they can be checked after each upstream merge.

## Branches

| Branch        | Purpose                                                                 |
|---------------|-------------------------------------------------------------------------|
| `custom/main` | Upstream `stable` (the released version) plus the changes below. Production Docker images are built from here. |
| `stable`      | Copy of `upstream/stable`, for reference only. Not needed to build or update. |
| `develop`     | Copy of `upstream/develop`, which is pre-release code. Never merge it into `custom/main`. |

`custom/main` followed `develop` until 2026-11-25, when it was moved onto the 7.3.0 release
by merging `upstream/stable`.

Pushing to `upstream` is disabled (`git remote set-url --push upstream DISABLED`).

## Updating from upstream

```bash
git fetch upstream --tags
git switch custom/main && git merge upstream/stable
# resolve conflicts with the checklist below, then
git push origin custom/main
```

Patch releases (7.3.1, 7.3.2, …) land on `upstream/stable` and merge in small steps. At a
new minor release upstream moves `stable` to the new line (for example 7.4), so that merge
is larger: read `BREAKING_CHANGES.md` and the release notes first.

Use merge, not rebase: `custom/main` is published, and rebasing would rewrite its history.

After every merge:

1. Check that each file in the tables below still has its change.
2. Look for new branding that upstream may have added:

   ```bash
   grep -rn "Powered by\|zammad\.org\"\|'https://zammad.org'" \
     app/assets/javascripts/app/views app/frontend/apps app/views \
     --include=*.eco --include=*.vue --include=*.erb | grep -v __tests__
   ```

## Merge driver for brand images

`.gitattributes` marks the binary brand images `merge=ours`, so an upstream change to
them never replaces ours. Git needs the driver defined once per clone:

```bash
git config merge.ours.driver true
```

`public/assets/images/icons.svg` is deliberately left out: upstream adds new icons to
that sprite, so conflicts there must be resolved by hand, keeping our `icon-logo` and
`icon-full-logo` symbols.

## Changes

### Branding: no "Powered by Zammad"

Clients must not see the Zammad name.

| File | Change |
|------|--------|
| `app/assets/javascripts/app/views/login.jst.eco` | "Powered by" footer removed |
| `app/assets/javascripts/app/views/signup.jst.eco` | same |
| `app/assets/javascripts/app/views/signup/verify.jst.eco` | same |
| `app/assets/javascripts/app/views/password/reset.jst.eco` | same |
| `app/assets/javascripts/app/views/password/reset_sent.jst.eco` | same |
| `app/assets/javascripts/app/views/password/reset_change.jst.eco` | same |
| `app/assets/javascripts/app/views/password/reset_failed.jst.eco` | same |
| `app/assets/javascripts/app/views/admin_password_auth/request.jst.eco` | same |
| `app/assets/javascripts/app/views/admin_password_auth/request_sent.jst.eco` | same |
| `app/assets/javascripts/app/views/profile/language.jst.eco` | "Help translating Zammad" hint removed |
| `app/frontend/apps/desktop/components/layout/LayoutPublicPage/LayoutPublicPage.vue` | "Powered by" footer removed |
| `app/frontend/apps/mobile/pages/authentication/components/LoginFooter.vue` | deleted |
| `app/frontend/apps/mobile/pages/authentication/views/Login.vue` | `LoginFooter` usage removed |
| `app/frontend/apps/mobile/pages/authentication/views/LoginAfterAuth.vue` | `LoginFooter` usage removed |
| `app/frontend/apps/desktop/pages/authentication/__tests__/login-product-branding.spec.ts` | asserts the footer is absent |
| `app/frontend/apps/mobile/pages/authentication/__tests__/login-public-links.spec.ts` | asserts the footer is absent |

### Branding: product name instead of "Zammad"

| File | Change |
|------|--------|
| `app/views/init/index.html.erb` | noscript text uses the `product_name` setting |
| `app/views/init/spinner-loading.html.erb` | same |
| `app/controllers/mobile_controller.rb` | PWA `short_name` uses the organization or product name |

The browser tab title, app header and notification emails already use the
`product_name` setting (Admin → Settings → Branding). It lives in the database, not in
this repository.

### Branding: logo and icons

| File | Change |
|------|--------|
| `public/assets/images/icons/logo.svg` | our logo |
| `public/assets/images/icons/full-logo.svg` | our logo (setup wizard) |
| `public/assets/images/icons.svg` | `icon-logo` and `icon-full-logo` symbols replaced |
| `public/assets/images/logo.svg` | our logo (default product logo, desktop notifications) |
| `app/frontend/apps/desktop/initializer/assets/logo.svg` | our logo (new desktop UI) |
| `public/favicon.ico` | our logo, 16–64 px |
| `public/apple-touch-icon.png` | our logo, 152 px |
| `public/assets/frontend/app-icon-192.png` | our logo, 192 px |
| `public/assets/frontend/app-icon-512.png` | our logo, 512 px |

The PNG and ICO files are generated from a 94 px source. Regenerate them from a
higher-resolution logo when one is available.

### Not changed on purpose

- `public/assets/images/icons/logotype.svg` and the `logo-flat` Vue icons still show
  Zammad, but nothing a client can see uses them after the footer removal.
- Links to admin-docs.zammad.org appear only on admin screens.
- Zammad is AGPL-3.0. Removing the name is allowed, but users of this modified version
  must be able to get its source. This public fork covers that.
