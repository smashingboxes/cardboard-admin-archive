require 'rails_helper'

RSpec.describe Cardboard::Page, type: :model do
  subject(:page) { build :page }

  it { is_expected.to be_valid }

  describe 'when persisted' do
    before { page.save }

    it 'it must be findable by url' do
      expect(Cardboard::Page.find_by_url page.url).to eq page
    end

    describe 'SEO' do
      before do
        page.update_attribute :position_position, 1
        page.update_attribute :meta_seo, {'title' => 'Test Title'}
        @subpages = create_list :page, 2, path: page.url
        @root_sibling = create :page, position_position: 2
      end

      it 'inherits SEO information from parent' do
        expect(@subpages.first.seo['title']).to eq page.seo['title']
      end

      it 'inherits SEO information from root' do
        expect(@root_sibling.seo['title']).to eq Cardboard::Page.root.seo['title']
      end

      it 'allows to override inherited properties' do
        @subpages.first.update_attribute :meta_seo, {'title' => 'Non root title'}
        expect(@subpages.first.seo['title']).not_to eq page.seo['title']
        expect(@subpages.first.seo['title']).to eq 'Non root title'
      end
    end

    describe 'Children' do
      before do
        @subpages = create_list(:page, 2, path: page.url)
      end

      it 'Must included newly created child' do
        @subpage = create :page, parent: page
        expect(page.children).to include @subpage
      end

      it 'Get the parent of a page' do
        expect(@subpages.first.parent).to eq page
      end

      it 'Get the children of a page' do
        expect(page.children).to include @subpages.first
        expect(page.children).to include @subpages.second
      end

      it 'Get the siblings of a page' do
        expect(@subpages.first.siblings).to include @subpages.second
        expect(@subpages.second.siblings).to include @subpages.first
      end

      it 'Preorder of results' do
        DatabaseCleaner.clean
        Cardboard::Page.clear_arranged_pages
        page1 = create :page, position_position: 1
        page2 = create :page, position_position: 2
        subpage1 = create :page, parent: page1, position_position: 1
        subpage2 = create :page, parent_id: page1.identifier, position_position: 2
        subpage3 = create :page, parent_url: subpage2.parent_url, position_position: 3
        subpage4 = create :page, parent_url: page2.url

        expect(Cardboard::Page.arrange).to eq({
          page1 => {
            subpage1 => {},
            subpage2 => {},
            subpage3 => {}
          },
          page2 => {subpage4 => {}}
        })

        expect(Cardboard::Page.root).to eq page1
        expect(Cardboard::Page.root.depth).to eq 0
        expect(subpage1.depth).to eq 1
      end
    end

  end
end

# require 'test_helper'
#
# #TODO: get, parent_url_options
#
# describe Cardboard::Page do
#   before do
#     @page = build(:page)
#   end
#
#   it 'Must be valid' do
#     @page.valid?).to equal true
#   end
#
#   describe 'Persisted record' do
#     before do
#       @page.save
#     end
#
#     it 'Must find Page with url' do
#       Cardboard::Page.find_by_url(@page.url)).to equal @page
#     end
#
#     # FIXME: The using_slug_backup appears to be badly broken thought the
#     # undelying functionality (to find a page by url after it's been updated is
#     # working as intended.  This need heavy refactoring and/or removal if it's
#     # serving no purpose
#     it 'Must be found with old url after changing slug' do
#       old_url = @page.url
#       @page.update_attribute :slug, 'test'
#       Cardboard::Page.find_by_url(old_url)).to equal @page
#       # Cardboard::Page.find_by_url(old_url).using_slug_backup?).to equal true
#       Cardboard::Page.find_by_url(@page.url)).to equal @page
#       # Cardboard::Page.find_by_url(@page.url).using_slug_backup?).to equal false
#     end
#
#     describe 'SEO' do
#       before do
#         @page.update_attribute :position_position, 1
#         @page.update_attribute :meta_seo, {'title' => 'Test Title'}
#         @subpages = create_list :page, 2, path: @page.url
#         @root_sibling = create :page, position_position: 2
#       end
#
#       it 'inherits SEO information from parent' do
#         @subpages.first.seo['title']).to equal @page.seo['title']
#       end
#
#       it 'inherits SEO information from root' do
#         @root_sibling.seo['title']).to equal Cardboard::Page.root.seo['title']
#       end
#
#       it 'allows to override inherited properties' do
#         @subpages.first.update_attribute :meta_seo, {'title' => 'Non root title'}
#         @subpages.first.seo['title'].wont_equal @page.seo['title']
#         @subpages.first.seo['title']).to equal 'Non root title'
#       end
#     end
#
#     describe 'Children' do
#       before do
#         @subpages = create_list(:page, 2, path: @page.url)
#       end
#
#       it 'Must included newly created child' do
#         @subpage = create :page, parent: @page
#         @page.children).to include @subpage
#       end
#
#       it 'Get the parent of a page' do
#         @subpages.first.parent).to equal @page
#       end
#
#       it 'Get the children of a page' do
#         @page.children).to include @subpages.first
#         @page.children).to include @subpages.second
#       end
#
#       it 'Get the siblings of a page' do
#         @subpages.first.siblings).to include @subpages.second
#         @subpages.second.siblings).to include @subpages.first
#       end
#
#       it 'Preorder of results' do
#         DatabaseCleaner.clean
#         Cardboard::Page.clear_arranged_pages
#         page1 = create :page, position_position: 1
#         page2 = create :page, position_position: 2
#         subpage1 = create :page, parent: page1, position_position: 1
#         subpage2 = create :page, parent_id: page1.identifier, position_position: 2
#         subpage3 = create :page, parent_url: subpage2.parent_url, position_position: 3
#         subpage4 = create :page, parent_url: page2.url
#
#         Cardboard::Page.arrange).to equal({
#           page1 => {
#             subpage1 => {},
#             subpage2 => {},
#             subpage3 => {}
#           },
#           page2 => {subpage4 => {}}
#           })
#
#           Cardboard::Page.root).to equal page1
#           Cardboard::Page.root.depth).to equal 0
#           subpage1.depth).to equal 1
#         end
#       end
#     end
#   end
#
