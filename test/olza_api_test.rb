require "test_helper"

class OlzaApiTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::OlzaApi::VERSION
  end

  #test creates new shipments in Olza test panel based on test data!
  def test_create_shipment
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'your test api login'
    test_pwd = 'your test api password'
    test_language = 'cs'

    # for better understanding of data format, check olza logistic panel and olza api guides
    test_data = {
      payload: [
        {
            apiCustomRef: "Test11",
            preset: {
                senderCountry: "pl",
                recipientCountry: "pl",
                speditionCode: "GLS",
                shipmentType: "DIRECT",
                senderId: ""
            },
            sender: {
                senderName: "Name",
                senderAddress: "Street 2",
                senderCity: "City",
                senderZipcode: "12345",
                senderContactPerson: "Someone",
                senderEmail: "mail@mail.xx",
                senderPhone: "+41123456789"
            },
            recipient: {
                recipientFirstname: "FName",
                recipientSurname: "Lname",
                recipientAddress: "Street 1",
                recipientCity: "City",
                recipientZipcode: "12345",
                recipientContactPerson: "company",
                recipientEmail: "test@test.pl",
                recipientPhone: "+48123456789",
                pickupPlaceId: ""
            },
            services: {
                T12: false,
                XS: false,
                S12: true,
                S10: false,
                SAT: false,
                PALLET: false,
                CSP: false,
                SM2: "+48123456789",
                INS: 0
            },

            packages: {
                packageCount: 1,
                weight: 1,
                shipmentDescription: "description"
            },
            specific: {
                pick: true,
                shipmentPickupDate: ""
            }
        },
        {
            apiCustomRef: "Test1",
            preset: {
                senderCountry: "pl",
                recipientCountry: "pl",
                speditionCode: "GLS",
                shipmentType: "WAREHOUSE",
                senderId: ""
            },
            sender: {
                senderName: "Name",
                senderAddress: "Street 2",
                senderCity: "City",
                senderZipcode: "12345",
                senderContactPerson: "Someone",
                senderEmail: "mail@mail.xx",
                senderPhone: "+41123456789"
            },
            recipient: {
                recipientFirstname: "FName",
                recipientSurname: "Lname",
                recipientAddress: "Street 1",
                recipientCity: "City",
                recipientZipcode: "12345",
                recipientContactPerson: "company",
                recipientEmail: "test@test.pl",
                recipientPhone: "+48123456789",
                pickupPlaceId: ""
            },
            services: {
                T12: false,
                XS: false,
                S12: true,
                S10: false,
                SAT: false,
                PALLET: false,
                CSP: false,
                SM2: "+48123456789",
                INS: 0
            },

            packages: {
                packageCount: 1,
                weight: 1,
                shipmentDescription: "description"
            },
            specific: {
                pick: true,
                shipmentPickupDate: ""
            }
        }
      ]
    }
    client = OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.create_shipments(test_data)

    assert_equal 1, response.error_list.size
    assert_instance_of OlzaApi::Response, response
  end

  def test_get_statuses
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'your test login'
    test_pwd = 'your test password'
    test_language = 'cs'

    data = {payload:{shipmentList:[123456]}}

    client = OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.get_statuses(data)

    assert_instance_of Hash, response
  end

  # this test returns error in response, as test olza logistic panel is not conected to test version of Olza spedition system.
  # to process use production api connection
  def test_post_shipments
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'your test login'
    test_pwd = 'your test password'
    test_language = 'cs'

    data = {payload: {shipmentList: [123456]}} #use real Shipment ID

    client = OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.post_shipments(data)

    assert_instance_of Hash, response
  end

  # same problem as described above. Labels are unable to get as it needs information from Olza spedition system.
  def test_get_labels
    test_url = "https://test.panel.olzalogistic.com/api/v1"
    test_login = 'your test login'
    test_pwd = 'your test password'
    test_language = 'cs'

    data = {payload: {shipmentList: [123456]}} # use real Shipment ID

    client = OlzaApi::Client.new(test_login, test_pwd, test_url, test_language)
    response = client.get_labels(data)

    assert_instance_of Hash, response
  end

end
