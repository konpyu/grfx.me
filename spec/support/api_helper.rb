module ApiHelper

#  shared_examples_for '200 Success' do
#    its(:status) { should be(200) }
#    its(:body)   { should match_json_expression(result) }
#  end
#
#  shared_examples_for '201 Created' do
#    its(:status) { should be(201) }
#    its(:body)   { should match_json_expression(result) }
#  end
#
#  shared_examples_for '204 No Content' do
#    its(:status) { should be(204) }
#    its(:body)   { should eq('') }
#  end
#
#  shared_examples_for '404 Not Found' do
#    its(:status) { should be(404) }
#    its(:body)   { should match_json_expression({ message: '404 Not Found' }) }
#  end
#
#  shared_examples_for '422 Unprocessable Entity' do
#    its(:status) { should be(422) }
#    its(:body)   { should match_json_expression({ message: '422 Unprocessable Entity' }) }
#  end

  def json_response
    JSON.parse(response.body)
  end

end
