require 'rails_helper'

describe RefreshProjectJob, type: :job do
  it 'should refresh job' do
    project = create :project
    expect(project).to receive(:refresh)
    RefreshProjectJob.perform_now project
  end
end
