require "rails_helper"

describe Admin::ModelLoadingService do
  context 'when #call' do
    let!(:categories) { create_list(:category, 15) }

    context 'when params are present' do
      # Aqui são os registros que eu quero que sejam exibidos após minha pesquisa
      let!(:search_categories) do
        categories = []
        15.times {|n| categories << create(:category, name: "Search #{n + 1}")}
        categories
      end

      # Os parametros enviados para o serviço
      let(:params) do
        {search: {name: "Search"}, order: {name: :desc}, page: 2, length: 4}
      end

      it 'returns right :lenght following pagination' do
        # describe_class sempre se refere a classe definida no teste, nesse caso é o Admin::ModelLoadingService
        service = described_class.new(Category.all, params)
        result_categories = service.call
        expect(result_categories.count).to eq 4
      end

      it 'returns the records by params given' do
        # Aqui eu estou ordenando de forma decrescente pelo name. Por isso o método sort! com o operador <=>
        search_categories.sort! { |a, b| b[:name] <=> a[:name] }
        service = described_class.new(Category.all, params)
        result_categories = service.call
        expected_categories = search_categories[4..7] # Retirando o array os esperados 4 registros da página 2
        expect(result_categories).to contain_exactly *expected_categories
      end
    end

    context 'when params aren\'t present' do
      it 'returns default :lenght pagination' do
        service = described_class.new(Category.all, nil)
        result_categories = service.call
        expect(result_categories.count).to eq 10
      end

      it 'returns the first 10 records' do
        service = described_class.new(Category.all, nil)
        result_categories = service.call
        expected_categories = categories[0..9]
        expect(result_categories).to contain_exactly *expected_categories
      end
    end
  end
end
