# Helper methods defined here can be accessed in any controller or view in the application

module Embadge
  class App
    module BadgeHelper
      def badge_options()

      end

      def badge_config params
        versionString = version_string(params)
        labelText = params[:label] || 'ember-versions'
        separator = (labelText.length + 4) * 6
        width = separator + (versionString.length + 4) * 6
        versionWidth = width - separator
        textPosition = separator + (width - separator)/2
        labelPosition = separator / 2

        {
          versionString: versionString,
          labelText: labelText,
          separator: separator,
          width: width,
          versionWidth: versionWidth,
          textPosition: textPosition,
          labelPosition: labelPosition,
          params: params
        }
      end

      def version_string object
        if object[:start].present? && SemanticRange.valid(object[:start])
          str = object[:start]
          if object[:end].present? && SemanticRange.valid(object[:end]) && SemanticRange.lt(object[:start], object[:end])
            str += ' - ' + object[:end]
          elsif object[:end].present? && (!SemanticRange.valid(object[:end]) || !SemanticRange.lt(object[:start], object[:end]))
            str = 'Invalid'
          else
            str += '+'
          end
        elsif object[:range].present? && SemanticRange.valid_range(object[:range])
          str = SemanticRange.valid_range object[:range]
        else
          str = 'Invalid'
        end
      end
    end

    helpers BadgeHelper
  end
end
