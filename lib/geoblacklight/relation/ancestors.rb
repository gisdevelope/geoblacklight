module Geoblacklight
  module Relation
    class Ancestors
      def initialize(id, repository)
        @search_id = id
        @repository = repository
      end

      def create_search_params
        slug_f = Settings.FIELDS.LAYER_SLUG
        { fq: ["{!join from=#{Settings.FIELDS.SOURCE} to=#{slug_f}}#{slug_f}:#{@search_id}"],
          fl: [Settings.FIELDS.TITLE, slug_f] }
      end

      def execute_query
        @repository.connection.send_and_receive(
          @repository.blacklight_config.solr_path,
          params: create_search_params
        )
      end

      def results
        response = execute_query
        response['response']
      end
    end
  end
end
