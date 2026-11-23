// Copyright (C) 2012-2026 Zammad Foundation, https://zammad-foundation.org/

import { visitView } from '#tests/support/components/visitView.ts'
import { mockApplicationConfig } from '#tests/support/mock-applicationConfig.ts'
import '#tests/graphql/builders/mocks.ts'

const applicationConfig = {
  product_name: 'Zammad Example App',
  product_logo: 'example-logo.svg',
}

describe('testing login product branding', () => {
  beforeEach(() => {
    mockApplicationConfig(applicationConfig)
  })

  it('check that expected product name is present', async () => {
    const view = await visitView('/login')

    expect(view.getByText(applicationConfig.product_name)).toBeInTheDocument()
  })

  it('does not render a powered by footer', async () => {
    const view = await visitView('/login')

    expect(view.queryByText('Powered by')).not.toBeInTheDocument()
    expect(view.queryByIconName('logo-flat')).not.toBeInTheDocument()
  })
})
