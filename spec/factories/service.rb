class Service
  attr_accessor :id, :accepted_payments, :alternate_name, :audience, :description, :eligibility,
                :email, :fees, :funding_sources, :application_process, :interpretation_services,
                :keywords, :languages, :name, :required_documents, :service_areas, :status, :website,
                :wait_time
end

FactoryBot.define do
  factory :service do
    id { (1..100).to_a.sample }
    accepted_payments { %w[Cash Check Credit\ Card] }
    alternate_name { Faker::Pokemon.name }
    audience { 'Adult alcoholic/drug addictive men and women with social and spiritual problems' }
    description do
      'Provides a long-term (6-12 month) residential rehabilitation program for men and women with
      substance abuse and other problems. Residents receive individual counseling, and drug and alcohol education.'
    end
    eligibility { 'Age 21-60, detoxed, physically able and willing to participate in a work therapy program' }
    email { Faker::Internet.email }
    fees { 'None' }
    funding_sources { %w[donations sales] }
    application_process { 'Walk in or through other agency referral' }
    interpretation_services { 'We offer 3-way interpretation services over the phone via Propio Language Services (http://propio-ls.com).' }
    keywords { %W[#{Faker::Superhero.power} #{Faker::Superhero.power}] }
    languages { %w[English Spanish] }
    name { Faker::Pokemon.name }
    required_documents { ['Government-issued picture identification'] }
    service_areas { %w[Alameda\ County San\ Mateo\ County] }
    status { 'active' }
    website { 'http://www.example.com' }
    wait_time { 'Available Today' }
  end
end
