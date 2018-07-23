module Geoblacklight
  module Relation
    class Ancestors
      def initialize(id, repository)
        @search_id = id
        @repository = repository
      end

      def create_search_params
        { fq: ["{!join from=#{Settings.FIELDS.SOURCE} to=#{Settings.FIELDS.LAYER_SLUG}}#{Settings.FIELDS.LAYER_SLUG}:#{@search_id}"],
          fl: [Settings.FIELDS.TITLE, Settings.FIELDS.LAYER_SLUG] }
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
