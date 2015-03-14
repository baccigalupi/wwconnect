require 'rails_helper'

RSpec.describe LinkedInAuthenticationParser do
  let(:parser) { LinkedInAuthenticationParser.new(data) }
  let(:data) { OmniAuth::AuthHash.new(sample_linkedin_data) }

  it "builds the right hash" do
    expect(parser.attrs).to eq({
      first_name:   'Kane',
      last_name:    'Baccigalupi',
      uid:          "yEQgerbil",
      provider:     'linkedin',
      email:        'baccigalup@gmail.com',
      title:        'Coder, Teacher, Fixer',
      location:     'San Francisco Bay Area',
      image:        "https://media.licdn.com/mpr/mprx/0_SmdaAVHwq-PXHQ3gfuVjAMoVNthWHLKg72jlAMwVwBqZcTbj3eJGxJ0qsp8BwGlluSIrOOJH9d5n",
      linkedin_url: "https://www.linkedin.com/pub/kane-baccigalupi/7/29b/916"
    })
  end

  context 'when nested data is not present' do
    let(:data) { 
      d = OmniAuth::AuthHash.new(sample_linkedin_data)
      d.delete(:info)
      d
    }

    it 'does not explode' do
      expect { parser.attrs }.not_to raise_error
    end
  end
end
