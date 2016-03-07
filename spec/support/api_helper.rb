require 'json_expressions/rspec'

module ApiHelper
  include Rack::Test::Methods

  def domain
    ''
  end

  def default_rack_env
    { 'HTTP_HOST' => domain }
  end

  shared_context 'api' do
    subject do
      if method == 'get'
        get(url, parameters, rack_env)
      elsif method == 'post'
        post(url, parameters, rack_env)
      elsif method == 'put'
        put(url, parameters, rack_env)
      elsif method == 'delete'
        delete(url, parameters, rack_env)
      elsif method == 'patch'
        patch(url, parameters, rack_env)
      end
    end
    let(:parameters) { '' }
    let(:rack_env)   { default_rack_env }
  end

  shared_examples_for '200 Success' do
    its(:status) { is_expected.to be(200) }
    its(:body)   { is_expected.to match_json_expression(result) }
  end

  shared_examples_for '201 Created' do
    its(:status) { is_expected.to be(201) }
    its(:body)   { is_expected.to match_json_expression(result) }
  end

  shared_examples_for '202 Accepted' do
    its(:status) { is_expected.to be(202) }
    its(:body)   { is_expected.to match_json_expression(result) }
  end

  shared_examples_for '204 No Content' do
    describe '#status' do
      subject { super().status }
      it { is_expected.to be(204) }
    end

    describe '#body' do
      subject { super().body }
      it { is_expected.to eq('') }
    end
  end

  shared_examples_for '400 Bad Request' do
    its(:status) { is_expected.to be(400) }
    its(:body)   { is_expected.to match_json_expression(error: wildcard_matcher) }
  end

  shared_examples_for '401 Unauthorized' do
    its(:status) { is_expected.to be(401) }
    its(:body)   { is_expected.to match_json_expression(error: wildcard_matcher) }
  end

  shared_examples_for '403 Forbidden' do
    its(:status) { is_expected.to be(403) }
    its(:body)   { is_expected.to match_json_expression(error: wildcard_matcher) }
  end

  shared_examples_for '404 Not Found' do
    describe '#status' do
      subject { super().status }
      it { is_expected.to be(404) }
    end

    describe '#body' do
      subject { super().body }
      it { is_expected.to match_json_expression(error: 'Not Found') }
    end
  end

  shared_examples_for '422 Unprocessable Entity' do
    describe '#status' do
      subject { super().status }
      it { is_expected.to be(422) }
    end

    describe '#body' do
      subject { super().body }
      it { is_expected.to match_json_expression(message: '422 Unprocessable Entity') }
    end
  end
end
