module Admin
  class ProductSavingService < ApplicationService
    class NotSavedProductError < StandardError; end

    attr_reader :product, :errors

    def initialize(params, product = nil)
      params = params.deep_symbolize_keys
      # Aqui eu separo com o reject os valores só da entidade Product
      @product_params = params.reject { |key| key == :productable_attributes }
      @productable_params = params[:productable_attributes] || {}
      @errors = {}
      @product = product || Product.new # Ou ele atualiza um já existente ou cria um novo
    end

    def call
      Product.transaction do
        @product.attributes = @product_params.reject { |key| key == :productable }
        build_productable
      ensure # Força a chamada do método save! para assegurar que será salvo ou lançado erros
        save!
      end
    end

    private 

    def build_productable
      @product.productable ||= @product_params[:productable].camelcase.safe_constantize.new
      @product.productable.attributes = @productable_params
    end

    def save!
      save_record!(@product.productable) if @product.productable.present?
      save_record!(@product)
      raise NotSavedProductError if @errors.present?
    rescue => e
      raise NotSavedProductError
    end

    def save_record!(record)
      record.save!
    rescue ActiveRecord::RecordInvalid
      @errors.merge!(record.errors.messages)
    end
  end
end
