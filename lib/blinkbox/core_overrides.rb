class Hash
  def deep_set(deep_key, value)
    path_keys = deep_key.split('.')
    final_key = path_keys.pop

    sub_obj = self
    path_keys.each do |k|
      sub_obj[k.to_sym] ||= {}
      sub_obj = sub_obj[k.to_sym]
    end

    sub_obj[final_key.to_sym] = value
  end
end