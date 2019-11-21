require "toribarenault/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Toribarenault
  class Error < StandardError; end
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website - Novos - Pinheiros'
        },
        {
          email_id: 'website',
          name: 'Website - Novos - Lapa'
        },
        {
          email_id: 'website',
          name: 'Website - Novos - Pirituba'
        },
        {
          email_id: 'website',
          name: 'Website - Master Day'
        },
        {
          email_id: 'website',
          name: 'Website - Master'
        },
        {
          email_id: 'website',
          name: 'Website - Seminovos - Lapa'
        },
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash
      model = parsed_email['o_cliente_est_interessado_em_um']

      product = parsed_email['veculo']
      product = model.split("\n").first if model

      type_of_response = parsed_email['deseja_resposta_por']
      store = parsed_email['unidade']
      store_name = store.split(" - ").last

      message = parsed_email['mensagem'] || ''


      message += "\nDeseja resposta por: #{type_of_response}" if type_of_response
      source = F1SalesCustom::Email::Source.all.map{ |s| s[:name] }.select { |n| n.include?(store_name) }.first

      source = F1SalesCustom::Email::Source.all[3][:name] if message.downcase.include?("me interesso em participar da 4ª maratona de vendas toriba renault")
      source = F1SalesCustom::Email::Source.all[4][:name] if (parsed_email['veculo'] || '').downcase.include?('master')
      source = F1SalesCustom::Email::Source.all[3][:name] if (parsed_email['oferta'] || '').downcase.include?('master day')
      source = F1SalesCustom::Email::Source.all[5][:name] if store_name.downcase.include?('lapa') && @email.subject.downcase.include?('seminovos')

      {
        source: {
          name: source,
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'],
          email: parsed_email['email']
        },
        product: product,
        message: message,
        description: "#{parsed_email['origem']} - #{store_name}",
      }

    end
  end
end
