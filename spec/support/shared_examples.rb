shared_examples 'a restricted area' do |method, action, *options|
  it 'should respond with success when no users exist' do
    send(method, action, *options)
    expect(response.status).to eq(200)
  end

  it 'should respond with 404 when users exists but signed out' do
    create :user
    send(method, action, *options)
    expect(response.status).to eq(404)
  end

  it 'should respond with 404 when signed in as user' do
    user = create :user, is_admin: false
    sign_in user
    send(method, action, *options)
    expect(response.status).to eq(404)
  end

  it 'should respond with success when signed in as admin' do
    user = create :user, is_admin: true
    sign_in user
    send(method, action, *options)
    expect(response.status).to eq(200)
  end
end
