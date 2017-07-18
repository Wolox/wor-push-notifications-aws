class SnsClientMock
  def create_platform_endpoint(params)
    { endpoint_arn: params[:token] }
  end

  def delete_endpoint(_endpoint_arn)
    true
  end

  def publish
    true
  end
end
