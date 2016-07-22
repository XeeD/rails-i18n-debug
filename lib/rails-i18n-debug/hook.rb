module I18n
  module Backend
    class Simple
      def lookup(locale, key, scope = [], options = {})
        init_translations unless initialized?

        keys = I18n.normalize_keys(locale, key, scope, options[:separator])
        location = keys.map {|k| " #{k}:"}.join
        i18n_logger.debug "I18N keys: #{location}" if Rails.env.development?

        keys.inject(translations) do |result, _key|
          _key = _key.to_sym
          return nil unless result.is_a?(Hash) && result.has_key?(_key)
          result = result[_key]
          result = resolve(locale, _key, result, options.merge(:scope => nil)) if result.is_a?(Symbol)

          i18n_logger.debug "\t\t => " + result.to_s + "\n" if Rails.env.development? && (result.class == String)

          result
        end
      end


      private

      def i18n_logger
        defined?(I18nLogger) ? I18nLogger : Rails.logger
      end
    end
  end
end
