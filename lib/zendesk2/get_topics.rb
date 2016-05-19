class Zendesk2::GetTopics
  include Zendesk2::Request

  request_path { |r| "/topics.json" }

  page_params!

  def mock
    page(:topics)
  end
end
