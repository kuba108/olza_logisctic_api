require "test_helper"

class OlzaApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OlzaApi::VERSION
  end

  #test creates new shipments in Olza test panel based on test data!
  def test_create_shipment
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'api_mixit'
    test_pwd = 'uKcFxtvmHA2X'
    test_language = 'cs'
    #used test data from api guide.
    test_data = {
          payload:
        [
        {
            apiCustomRef: "ABC",
            preset: {
                senderCountry: "cz",
                recipientCountry: "cz",
                speditionCode: "GLS",
                shipmentType: "WAREHOUSE",
                senderId: ""
            },
            sender: {
                senderName: "Firma XY",
                senderAddress: "Vysoká 1",
                senderCity: "Praha 1",
                senderZipcode: "12000",
                senderContactPerson: "Pepo Expedice",
                senderEmail: "+420123456789",
                senderPhone: "mail@firmaxy.cz"
            },
            recipient: {
                recipientFirstname: "Honza",
                recipientSurname: "Malý",
                recipientAddress: "Hlboká 135/15",
                recipientCity: "Ostrava",
                recipientZipcode: "70200",
                recipientContactPerson: "Pepa Bystrý",
                recipientEmail: "tachov@seznam.cz",
                recipientPhone: "+420123456789",
                pickupPlaceId: ""
            },
            services: {
                T12: true,
                XS: true,
                S12: true,
                S10: true,
                SAT: true,
                PALLET: true,
                CSP: true,
                SM2: "+420123456789",
                INS: 5000
            },
            cod: {
                codAmount: 50.6,
                codReference: "0123456789"
            },
            packages: {
                packageCount: 2,
                weight: 2.5,
                shipmentDescription: "Textil"
            },
            specific: {
                pick: true,
                shipmentPickupDate: "01.01.2022"
            }
        }
    ]
    }
    client = ::OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.create_shipments(test_data)

    #provided correct data, no error should occure
    assert_empty response[:response].errors
    #response variable is after JSON parse, should be Hash
    assert_instance_of Hash, response
  end

  def test_get_statuses
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'api_mixit'
    test_pwd = 'uKcFxtvmHA2X'
    test_language = 'cs'
    data = {payload:{shipmentList:[12884]}}

    client = ::OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.get_statuses(data)

    assert_instance_of Hash, response
  end
end
