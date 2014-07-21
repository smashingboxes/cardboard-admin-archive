require 'test_helper'

#TODO: get, parent_url_options

describe Cardboard::Page do
  before do
    @page = build(:page)
  end

  it 'Must be valid' do
    @page.valid?.must_equal true
  end

  describe 'Persisted record' do
    before do
      @page.save
    end

    it 'Must find Page with url' do
      Cardboard::Page.find_by_url(@page.url).must_equal @page
    end

    # FIXME: The using_slug_backup appears to be badly broken thought the
    # undelying functionality (to find a page by url after it's been updated is
    # working as intended.  This need heavy refactoring and/or removal if it's
    # serving no purpose
    it 'Must be found with old url after changing slug' do
      old_url = @page.url
      @page.update_attribute :slug, 'test'
      Cardboard::Page.find_by_url(old_url).must_equal @page
      # Cardboard::Page.find_by_url(old_url).using_slug_backup?.must_equal true
      Cardboard::Page.find_by_url(@page.url).must_equal @page
      # Cardboard::Page.find_by_url(@page.url).using_slug_backup?.must_equal false
    end

    describe 'SEO' do
      before do
        @page.update_attribute :position_position, 1
        @page.update_attribute :meta_seo, {'title' => 'Test Title'}
        @subpages = create_list :page, 2, path: @page.url
        @root_sibling = create :page, position_position: 2
      end
      
      it 'inherits SEO information from parent' do
        @subpages.first.seo['title'].must_equal @page.seo['title']
      end

      it 'inherits SEO information from root' do
        @root_sibling.seo['title'].must_equal Cardboard::Page.root.seo['title']
      end

      it 'allows to override inherited properties' do
        @subpages.first.update_attribute :meta_seo, {'title' => 'Non root title'}
        @subpages.first.seo['title'].wont_equal @page.seo['title']
        @subpages.first.seo['title'].must_equal 'Non root title'
      end
    end

    describe 'Children' do
      before do
        @subpages = create_list(:page, 2, path: @page.url)
      end

      it 'Must included newly created child' do
        @subpage = create :page, parent: @page
        @page.children.must_include @subpage
      end

      it 'Get the parent of a page' do
       @subpages.first.parent.must_equal @page
      end

      it 'Get the children of a page' do
        @page.children.must_include @subpages.first
        @page.children.must_include @subpages.second
      end

      it 'Get the siblings of a page' do
        @subpages.first.siblings.must_include @subpages.second
        @subpages.second.siblings.must_include @subpages.first
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

        Cardboard::Page.arrange.must_equal({
          page1 => {
            subpage1 => {}, 
            subpage2 => {}, 
            subpage3 => {}
          }, 
          page2 => {subpage4 => {}}
        })

        Cardboard::Page.root.must_equal page1
        Cardboard::Page.root.depth.must_equal 0
        subpage1.depth.must_equal 1
      end
    end
  end
end

