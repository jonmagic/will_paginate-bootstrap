require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = "&hellip;"

    def to_html
      list_items = pagination.map do |item|
        case item
          when Fixnum
            page_number(item)
          else
            send(item)
        end
      end.join(@options[:link_separator])

      tag("nav", tag("ul", list_items, class: ul_class), "aria-label": nav_aria_label)
    end

    def container_attributes
      super.except(*[:link_options])
    end

    protected

    def page_number(page)
      if page == current_page
        tag("li", link([page, tag("span", "(current)", class: "sr-only")], "#", class: "page-link", "tabindex": "-1"), class: "active disabled page-item")
      else
        tag("li", link(page, page, link_options.merge(rel: rel_value(page))), class: "page-item")
      end
    end

    def previous_or_next_page(page, text, classname, aria_text)
      inner_spans = [tag("span", text, "aria-hidden": "true"), tag("span", aria_text, class: "sr-only")]
      if page
        tag("li", link(inner_spans, page, link_options.merge("aria-label": text)), class: classname)
      else
        tag("li", link(inner_spans, "#", class: "page-link", "tabindex": "-1"), class: "%s disabled page-item" % classname)
      end
    end

    def gap
      tag("li", tag("span", ELLIPSIS), class: "disabled page-item")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], "prev", "Previous")
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], "next", "Next")
    end

    def ul_class
      ["pagination", @options[:class]].compact.uniq.join(" ")
    end

    def link_options
      (@options[:link_options] || {}).merge({class: "page-link"})
    end

    def nav_aria_label
      @options[:nav_aria_label] || "Page navigation"
    end
  end
end
