String stripHtml(String? html) {
  if (html == null) return '';

  // 1. Replace common block-level tags with newlines to preserve structure
  String text = html.replaceAll(RegExp(r'</?(p|div|br|h[1-6]|li)[^>]*>'), '\n');

  // 2. Remove all remaining HTML tags
  text = text.replaceAll(RegExp(r'<[^>]*>'), '');

  // 3. Decode common HTML entities
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');

  // 4. Normalize whitespace:
  // - Replace multiple spaces with a single space
  // - Trim each line
  // - Replace 3 or more newlines with 2 newlines
  text = text.split('\n')
      .map((line) => line.replaceAll(RegExp(r' +'), ' ').trim())
      .join('\n');

  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();

  return text;
}
