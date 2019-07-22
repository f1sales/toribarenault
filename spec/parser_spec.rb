require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when email is from website form' do

    context 'when is about an offer' do
      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websiteform@lojateste.f1sales.org']
        email.subject = 'Notificação de contato sobre oferta'
        email.body = "*NOTIFICAÇÃO DE CONTATO*\n\n\n\n*Oferta:*\n\nDuster Authentique 1.6 CVT a partir de R$ 46.391,89 com faturamento imediato\n\n*Data:*\n\n11/07 13:04\n\n\n\n*Nome:*\n\nWilson\n\n*Telefone:*\n\n11949205316\n\n*E-mail:*\n\nwilcarlos2014@gmail.com\n\n*Unidade:*\n\nToriba Renault - Pinheiros\n\n*Veículo:*\n\nDuster\n\n*Origem:*\n\ngoogle\n\n*Protocolo:*\n\n77316\n\n\n\n*Mensagem:*\n\nDuster Authentique 1.6 CVT PCD a partir de R$ 46.391,89 com faturamento\nimediato\n\n\n\nATENÇÃO: Não responda este e-mail. Trata-se de uma mensagem informativa e\nautomática.\n\n\n\n\n\nAtenciosamente,\n4Life Soluções em Marketing Digital\nhttp://www.4lifesistemas.com.br\n\nNada nesta mensagem tem a intenção de ser uma assinatura eletrônica a menos\nque uma declaração específica do contrário seja incluída.\nConfidencialidade: Esta mensagem é destinada somente à pessoa endereçada.\nPode conter material confidencial e/ou privilegiado. Qualquer revisão,\ntransmissão ou outro uso ou ação tomada por confiança é proibida e pode ser\nilegal. Se você recebeu esta mensagem por engano, entre em contato com o\nremetente e apague-a de seu computador."

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website form as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all.first[:name])
      end

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Wilson')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('wilcarlos2014@gmail.com')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11949205316')
      end

      it 'contains product' do
        expect(parsed_email[:product]).to eq('Duster')
      end

      it 'contains product' do
        expect(parsed_email[:description]).to eq('google')
      end

      it 'contains message' do
        expect(parsed_email[:message]).to eq("Duster Authentique 1.6 CVT PCD a partir de R$ 46.391,89 com faturamento\nimediato\nUnidade: Toriba Renault - Pinheiros")
      end

    end

    context 'when is about an used car' do
      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websiteform@lojateste.f1sales.org']
        email.subject = 'Notificação de contato - Seção Veículos Novos'
        email.body = "*NOTIFICAÇÃO DE CONTATO*\n\n\n\n*Data:*\n\n11/07 21:11\n\n\n\n*Nome:*\n\nRicardo Sibinel\n\n*Telefone:*\n\n1139769169\n\n*E-mail:*\n\nrsibinel@yahoo.com.br\n\n*Unidade:*\n\nToriba Renault - Pinheiros\n\n*Deseja resposta por:*\n\nTelefone\n\n*Protocolo:*\n\n77336\n\n\n\n*O cliente está interessado em um:*\n\nRenault Duster Oroch\n\n\n\n\n\nAtenciosamente,\nToriba Renault\nhttp://www.toribarenault.com.br\n\nNada nesta mensagem tem a intenção de ser uma assinatura eletrônica a menos\nque uma declaração específica do contrário seja incluída.\nConfidencialidade: Esta mensagem é destinada somente à pessoa endereçada.\nPode conter material confidencial e/ou privilegiado. Qualquer revisão,\ntransmissão ou outro uso ou ação tomada por confiança é proibida e pode ser\nilegal. Se você recebeu esta mensagem por engano, entre em contato com o\nremetente e apague-a de seu computador."

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website form as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all.first[:name])
      end

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Ricardo Sibinel')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('rsibinel@yahoo.com.br')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('1139769169')
      end

      it 'contains product' do
        expect(parsed_email[:product]).to eq('Renault Duster Oroch')
      end

      it 'contains message' do
        expect(parsed_email[:message]).to eq("\nDeseja resposta por: Telefone\nUnidade: Toriba Renault - Pinheiros")
      end
    end
  end


end
