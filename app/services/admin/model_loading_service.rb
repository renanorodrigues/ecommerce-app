module Admin  
  class ModelLoadingService < ApplicationService # Essa classe é uma típico exemplo de PORO - Pure and Old Ruby Object
    attr_reader :records, :pagination
    
    def initialize(searchable_modal, params = {})
      @searchable_modal = searchable_modal
      @params = params || {} # Atribui-se um hash vazio se a variável estiver sem nenhum valor
      @records = []
      @pagination = { page: @params[:page].to_i, length: @params[:length].to_i }
    end

    # O service não se importa qual model vai ser, contanto que implemente as buscas e a paginação
    # Logo, isso é um exemplo de Duck Typing. Não importa a variável e sim seu comportamento!
    def call
      fix_pagination_values
      filtered = search_records(@searchable_modal)
      @records = filtered.order(@params[:order].to_h).paginate(@pagination[:page], @pagination[:length])

      total_pages = (filtered.count / @pagination[:length].to_f).ceil
      @pagination.merge!(total: filtered.count, total_pages: total_pages)
    end

    private

    def fix_pagination_values
      @pagination[:page] = @searchable_modal.model::DEFAULT_PAGE if @pagination[:page] <= 0
      @pagination[:length] = @searchable_modal.model::MAX_PER_PAGE if @pagination[:length] <= 0
    end

    def search_records(searched)
      return searched unless @params.has_key?(:search)
      @params[:search].each do |key, value|
        searched = searched.like(key, value)
      end
      searched
    end
  end
end