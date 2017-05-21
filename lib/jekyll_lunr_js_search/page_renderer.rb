require 'nokogiri'

module Jekyll
  module LunrJsSearch
    class PageRenderer
      def initialize(site)
        @site = site
      end
      
      # render item, but without using its layout
      def prepare(item)
        layout = item.data["layout"]
        begin
          # leave an explicit nil as layout to prevent jekyll from falling back to the default
          # layout configured in the front matter defaults in _config.yml:
          item.data["layout"] = nil

          if item.is_a?(Jekyll::Document)          
            output = Jekyll::Renderer.new(@site, item).run
          else
            item.render({}, @site.site_payload)
            output = item.output  
          end
        ensure
          # restore original layout
          item.data["layout"] = layout
        end
      
        output
      end

      # render the item, parse the output and get all inner text (i.e. non-markup)
      # http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri%2FXML%2FNodeSet:inner_text
      def render(item)
        layoutless = item.dup
        Nokogiri::HTML(prepare(layoutless)).text
      end
    end
  end  
end