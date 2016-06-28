# encoding: UTF-8

require 'spec_helper'

CLIENT_ID = 'F7q38MzlwOxUwTHb7jvk'
CLIENT_SECRET = 'O8DRamKmKMLtSTPjK99eUlbfOQEc44VVmp8ARmcY'
SCHEDULE_AUTH_CODE = 'KmCCkuYkSmPEf7AxaCIUApX1pUFedJx9CrDWPMD8'
BASE_URL = 'https://platform.pokitdok.com/v4/api'
MATCH_NETWORK_LOCATION = /(.*\.)?pokitdok\.com/
MATCH_OAUTH2_PATH = /[\/]oauth2[\/]token/
TEST_REQUEST_PATH = '/endpoint'

describe PokitDok do
  describe 'Authenticated functions' do
    before do
      stub_request(:post, /#{MATCH_NETWORK_LOCATION}#{MATCH_OAUTH2_PATH}/).
          to_return(
              :status => 200,
              :body => '{
                  "access_token": "s8KYRJGTO0rWMy0zz1CCSCwsSesDyDlbNdZoRqVR",
                  "token_type": "bearer",
                  "expires": 1393350569,
                  "expires_in": 3600
              }',
              :headers => { 'Server'=> 'nginx',
                            'Date' => Time.now(),
                            'Content-type' => 'application/json;charset=UTF-8',
                            'Connection' => 'keep-alive',
                            'Pragma' => 'no-cache',
                            'Cache-Control' => 'no-store'})

      @pokitdok = PokitDok::PokitDok.new(CLIENT_ID, CLIENT_SECRET)
      @pokitdok.scope_code('user_schedule', SCHEDULE_AUTH_CODE)
    end

    describe 'Test Connection' do
      it 'should instantiate the client' do
        refute_nil(@pokitdok.client)
      end
    end

    # TODO: General Request Tests

    describe 'Activities endpoint' do
      it 'should expose the activities endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
                      to_return(status: 200, body: '{ "string" : "" }')

        @activities = @pokitdok.activities
        refute_nil(@activities)
      end

      it 'should expose the activities endpoint with an id parameter' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @activities = @pokitdok.activities(activity_id: 'activity_id')
        refute_nil(@activities)
      end
    end

    describe 'Cash Prices endpoint' do
      it 'should expose the cash prices endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = { cpt_code: '90658', zip_code: '94403' }
        @prices = @pokitdok.cash_prices query

        refute_nil(@prices)
      end
    end

    describe 'Claims endpoint' do
      it 'should expose the claims endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = JSON.parse(IO.read('spec/fixtures/claim.json'))
        @claim = @pokitdok.claims(query)

        refute_nil(@claim)
      end
    end

    describe 'Claims status endpoint' do
      it 'should expose the claims status endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = JSON.parse(IO.read('spec/fixtures/claims_status.json'))
        @claims_status = @pokitdok.claims_status(query)

        refute_nil(@claims_status)
      end
    end

    # TODO: MPC Tests

    # TODO: ICD Convert Tests

    describe 'Claims convert endpoint' do
      it 'should expose the claims convert endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @converted_claim = @pokitdok.claims_convert('spec/fixtures/chiropractic_example.837')

        refute_nil(@converted_claim)
      end
    end

    describe 'Eligibility endpoint' do
      it 'should expose the eligibility endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @eligibility_query = {
            member: {
                birth_date: '1970-01-01',
                first_name: 'Jane',
                last_name: 'Doe',
                id: 'W000000000'
            },
            provider: {
                first_name: 'JEROME',
                last_name: 'AYA-AY',
                npi: '1467560003'
            },
            service_types: ['health_benefit_plan_coverage'],
            trading_partner_id: 'MOCKPAYER'
        }
        @eligibility = @pokitdok.eligibility(@eligibility_query)

        refute_nil(@eligibility)
      end
    end

    describe 'Enrollment endpoint' do
      it 'should expose the enrollment endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = JSON.parse(IO.read('spec/fixtures/enrollment.json'))
        @enrollment = @pokitdok.enrollment(query)

        refute_nil(@enrollment)
      end
    end

    # TODO: Enrollment Snapshot Tests

    describe 'Files endpoint' do
      it 'should expose the files endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @files = @pokitdok.files('MOCKPAYER', 'spec/fixtures/sample.270')

        refute_nil(@files)
      end
    end

    describe 'Insurance Prices endpoint' do
      it 'should expose the insurance prices endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = { cpt_code: '87799', zip_code: '32218' }
        @prices = @pokitdok.insurance_prices query

        refute_nil(@prices)
      end
    end

    describe 'Payers endpoint' do
      it 'should expose the payers endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @payers = @pokitdok.payers(state: 'CA')

        refute_nil(@payers)
      end
    end

    describe 'Plans endpoint' do
      it 'should expose the plans endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @plans = @pokitdok.plans

        refute_nil(@plans)
      end

      it 'should expose the plans endpoint withe state and plan type' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {state: 'TX', plan_type: 'PPO'}
        @plans = @pokitdok.plans(query)

        refute_nil(@plans)
      end
    end

    describe 'Providers endpoint' do
      it 'should expose the providers endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = { npi: '1467560003' }
        @providers = @pokitdok.providers(query)

        refute_nil(@providers)
      end

      it 'should expose the providers endpoint with args' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = { zipcode: '29307',
                  specialty: 'rheumatology',
                  radius: '20mi' }
        @providers = @pokitdok.providers(query)

        refute_nil(@providers)
      end
    end

    describe 'Trading Partners endpoints' do
      it 'should expose the trading partners endpoint (index call)' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @trading_partners = @pokitdok.trading_partners

        refute_nil(@trading_partners)
      end

      it 'should expose the trading partners endpoint (get call)' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @trading_partners = @pokitdok.trading_partners({ trading_partner_id: 'aetna' })

        refute_nil(@trading_partners)
      end
    end

    describe 'Referrals endpoint' do
      it 'should expose the referrals endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = JSON.parse(IO.read('spec/fixtures/referrals.json'))
        @referrals = @pokitdok.referrals(query)

        refute_nil(@referrals)
      end
    end

    describe 'Authorizations endpoint' do
      it 'should expose the authorizations endpoint' do
        stub_request(:post, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = JSON.parse(IO.read('spec/fixtures/authorizations.json'))
        @authorizations = @pokitdok.authorizations query

        refute_nil(@authorizations)
      end
    end

    describe 'Scheduling endpoints' do
      it 'should list the schedulers' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @schedulers = @pokitdok.schedulers

        refute_nil(@schedulers)
      end

      it 'should give details on a specific scheduler' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @scheduler = @pokitdok.scheduler({ uuid: '967d207f-b024-41cc-8cac-89575a1f6fef' })

        refute_nil(@scheduler)
      end

      it 'should list appointment types' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @appointment_types = @pokitdok.appointment_types

        refute_nil(@appointment_types)
      end

      it 'should give details on a specific appointment type' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @appointment_type = @pokitdok.appointment_type({ uuid: 'ef987695-0a19-447f-814d-f8f3abbf4860' })

        refute_nil(@appointment_type)
      end

      # TODO: /schedule/slots test

      it 'should give details on a specific appointment' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @appointment = @pokitdok.appointments({ uuid: 'ef987691-0a19-447f-814d-f8f3abbf4859' })

        refute_nil(@appointment)
      end

      it 'should give details on a searched appointments' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {
            'appointment_type' => 'AT1',
            'start_date' => Time.now.strftime("%Y/%m/%d"),
            'end_date' => Time.now.strftime("%Y/%m/%d"),
        }
        @appointments = @pokitdok.appointments(query)

        refute_nil(@appointments)
      end

      it 'should book appointment for an open slot' do
        stub_request(:put, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        appt_uuid = "ef987691-0a19-447f-814d-f8f3abbf4859"
        booking_query = {
            patient: {
                _uuid: "500ef469-2767-4901-b705-425e9b6f7f83",
                email: "john@johndoe.com",
                phone: "800-555-1212",
                birth_date: "1970-01-01",
                first_name: "John",
                last_name: "Doe",
                member_id: "M000001"
            },
            description: "Welcome to M0d3rN Healthcare"
        }
        @slot = @pokitdok.book_appointment(appt_uuid, booking_query)

        refute_nil(@slot)
      end

      it 'should cancel a specified appointment' do
        stub_request(:delete, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        @cancel_response = @pokitdok.cancel_appointment "ef987691-0a19-447f-814d-f8f3abbf4859"

        refute_nil(@cancel_response)
      end
    end

    # TODO: /identity/ tests

    describe 'Pharmacy Plans Endpoint' do
      it 'should expose the pharmacy plans endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {trading_partner_id: 'MOCKPAYER', plan_number: 'S5820003'}
        @pharmacy_plans = @pokitdok.pharmacy_plans(query)

        refute_nil(@pharmacy_plans)
      end
    end

    describe 'Pharmacy Formulary Endpoint' do
      it 'should expose the pharmacy formulary endpoint' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {trading_partner_id: 'MOCKPAYER', plan_number: 'S5820003',
                 ndc: '59310-579-22'}
        @pharmacy_formulary = @pokitdok.pharmacy_formulary(query)

        refute_nil(@pharmacy_formulary)
      end
    end

    describe 'Pharmacy Network Endpoint' do
      it 'should expose the pharmacy formulary endpoint by NPI' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {trading_partner_id: 'MOCKPAYER', plan_number: 'S5596033',
                 npi: '1912301953'}
        @pharmacy_network = @pokitdok.pharmacy_network(query)

        refute_nil(@pharmacy_network)
      end
      it 'should expose the pharmacy formulary endpoint by searching' do
        stub_request(:get, MATCH_NETWORK_LOCATION).
            to_return(status: 200, body: '{ "string" : "" }')

        query = {trading_partner_id: 'MOCKPAYER', plan_number: 'S5596033',
                 zipcode: '94401', radius: '10mi'}
        @pharmacy_network = @pokitdok.pharmacy_network(query)

        refute_nil(@pharmacy_network)
      end
    end
  end
end
