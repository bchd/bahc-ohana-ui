module Ohanakapa
  class Client
    module RecommendedTags
      def recommended_tags
        get("recommended_tags")
      end
    end
  end
end

module Ohanakapa
  class Client
    include Ohanakapa::Client::RecommendedTags
  end
end
