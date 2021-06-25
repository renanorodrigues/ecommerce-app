module Admin  
  class ModelLoadingService < ApplicationService # Essa classe é uma típico exemplo de PORO - Pure and Old Ruby Object
    def initialize(searchable_modal, params = {})
      @searchable_modal = searchable_modal
      @params = params
      @params ||= {} # Atribui-se um hash vazio se a variável estiver sem nenhum valor
    end

    # O service não se importa qual model vai ser, contanto que implemente as buscas e a paginação
    # Logo, isso é um exemplo de Duck Typing. Não importa a variável e sim seu comportamento!
    def call
      @searchable_modal.search_by_name(@params.dig(:search, :name))
                       .order(@params[:order].to_h)
                       .paginate(@params[:page].to_i, @params[:length].to_i)
    end
  end
end