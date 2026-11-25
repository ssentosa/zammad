# Copyright (C) 2012-2026 Zammad Foundation, https://zammad-foundation.org/

require 'rails_helper'

RSpec.describe 'Navigation', type: :system do
  before { visit '/' }

  context 'when mobile', screen_size: :mobile do
    it 'widens navigation bar on clicking button' do
      expect { click '.js-navigation-toggle-button' }
        .to change { navigation_collapsed? }
        .to(false)
    end

    it 'widens navigation bar on opening search' do
      expect { click '#global-search' }
        .to change { navigation_collapsed? }
        .to(false)
    end
  end

  context 'when tablet', screen_size: :tablet do
    it 'collapses navigation bar on clicking button' do
      expect { click '.js-navigation-toggle-button' }
        .to change { navigation_collapsed? }
        .to(true)
    end
  end

  context 'when desktop', screen_size: :desktop do
    it 'does not show collapse button' do
      expect(page).to have_no_css '.js-navigation-toggle-button'
    end

    it 'shows full navigation bar' do
      expect(navigation_collapsed?).to be_falsey
    end
  end

  def navigation_current_width
    evaluate_script("$('#navigation').width()")
  end

  def navigation_collapsed?
    navigation_current_width == 50
  end

  describe 'links to documentation', authenticated_as: :user do
    before { click '.navbar-items-personal .js-avatar' }

    # This fork removes the links to the Zammad documentation for everyone.
    shared_examples 'showing no links to documentation' do
      it 'shows no links to documentation' do
        expect(page).to have_no_text('Admin Documentation').and(have_no_text('User Documentation'))
      end
    end

    context 'when a customer' do
      let(:user) { create(:customer) }

      it_behaves_like 'showing no links to documentation'
    end

    context 'when an agent' do
      let(:user) { create(:agent) }

      it_behaves_like 'showing no links to documentation'
    end

    context 'when an admin' do
      let(:role) { create(:role, permission_names: ['admin']) }
      let(:user) { create(:user, roles: [role]) }

      it_behaves_like 'showing no links to documentation'
    end

    context 'when an admin and agent' do
      let(:user) { create(:admin) }

      it_behaves_like 'showing no links to documentation'
    end

    context 'when reports reader' do
      let(:role) { create(:role, permission_names: ['report']) }
      let(:user) { create(:user, roles: [role]) }

      it_behaves_like 'showing no links to documentation'
    end
  end
end
