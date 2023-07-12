import ballerina/lang.regexp;
import ballerina/http;

public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "https://accounts.google.com/o/oauth2/token";
|};

# Sets a data validation rule to every cell in the range. To clear validation in a range, call this with no rule specified.
public type SetDataValidationRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # A data validation rule.
    DataValidationRule rule?;
};

# Clears the basic filter, if any exists on the sheet.
public type ClearBasicFilterRequest record {
    # The sheet ID on which the basic filter should be cleared.
    int:Signed32 sheetId?;
};

# The format of a cell.
public type CellFormat record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color backgroundColor?;
    # A color value.
    ColorStyle backgroundColorStyle?;
    # The borders of the cell.
    Borders borders?;
    # The horizontal alignment of the value in the cell.
    "HORIZONTAL_ALIGN_UNSPECIFIED"|"LEFT"|"CENTER"|"RIGHT" horizontalAlignment?;
    # If one exists, how a hyperlink should be displayed in the cell.
    "HYPERLINK_DISPLAY_TYPE_UNSPECIFIED"|"LINKED"|"PLAIN_TEXT" hyperlinkDisplayType?;
    # The number format of a cell.
    NumberFormat numberFormat?;
    # The amount of padding around the cell, in pixels. When updating padding, every field must be specified.
    Padding padding?;
    # The direction of the text in the cell.
    "TEXT_DIRECTION_UNSPECIFIED"|"LEFT_TO_RIGHT"|"RIGHT_TO_LEFT" textDirection?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
    # The rotation applied to text in a cell.
    TextRotation textRotation?;
    # The vertical alignment of the value in the cell.
    "VERTICAL_ALIGN_UNSPECIFIED"|"TOP"|"MIDDLE"|"BOTTOM" verticalAlignment?;
    # The wrap strategy for the value in the cell.
    "WRAP_STRATEGY_UNSPECIFIED"|"OVERFLOW_CELL"|"LEGACY_WRAP"|"CLIP"|"WRAP" wrapStrategy?;
};

# A combination of a source range and how to extend that source.
public type SourceAndDestination record {
    # The dimension that data should be filled into.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" dimension?;
    # The number of rows or columns that data should be filled into. Positive numbers expand beyond the last row or last column of the source. Negative numbers expand before the first row or first column of the source.
    int:Signed32 fillLength?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange 'source?;
};

# A group over an interval of rows or columns on a sheet, which can contain or be contained within other groups. A group can be collapsed or expanded as a unit on the sheet.
public type DimensionGroup record {
    # This field is true if this group is collapsed. A collapsed group remains collapsed if an overlapping group at a shallower depth is expanded. A true value does not imply that all dimensions within the group are hidden, since a dimension's visibility can change independently from this group property. However, when this property is updated, all dimensions within it are set to hidden if this field is true, or set to visible if this field is false.
    boolean collapsed?;
    # The depth of the group, representing how many groups have a range that wholly contains the range of this group.
    int:Signed32 depth?;
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# A group name and a list of items from the source data that should be placed in the group with this name.
public type ManualRuleGroup record {
    # The kinds of value that a cell in a spreadsheet can have.
    ExtendedValue groupName?;
    # The items in the source data that should be placed into this group. Each item may be a string, number, or boolean. Items may appear in at most one group within a given ManualRule. Items that do not appear in any group will appear on their own.
    ExtendedValue[] items?;
};

# Updates an embedded object's border property.
public type UpdateEmbeddedObjectBorderRequest record {
    # A border along an embedded object.
    EmbeddedObjectBorder border?;
    # The fields that should be updated. At least one field must be specified. The root `border` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # The ID of the embedded object to update.
    int:Signed32 objectId?;
};

# The response when clearing a range of values in a spreadsheet.
public type BatchClearValuesResponse record {
    # The ranges that were cleared, in A1 notation. If the requests are for an unbounded range or a ranger larger than the bounds of the sheet, this is the actual ranges that were cleared, bounded to the sheet's limits.
    string[] clearedRanges?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
};

# Settings to control how circular dependencies are resolved with iterative calculation.
public type IterativeCalculationSettings record {
    # When iterative calculation is enabled and successive results differ by less than this threshold value, the calculation rounds stop.
    decimal convergenceThreshold?;
    # When iterative calculation is enabled, the maximum number of calculation rounds to perform.
    int:Signed32 maxIterations?;
};

# The result of adding a banded range.
public type AddBandingResponse record {
    # A banded (alternating colors) range in a sheet.
    BandedRange bandedRange?;
};

# Criteria for showing/hiding rows in a pivot table.
public type PivotFilterCriteria record {
    # A condition that can evaluate to true or false. BooleanConditions are used by conditional formatting, data validation, and the criteria in filters.
    BooleanCondition condition?;
    # Whether values are visible by default. If true, the visible_values are ignored, all values that meet condition (if specified) are shown. If false, values that are both in visible_values and meet condition are shown.
    boolean visibleByDefault?;
    # Values that should be included. Values not listed here are excluded.
    string[] visibleValues?;
};

# A rule describing a conditional format.
public type ConditionalFormatRule record {
    # A rule that may or may not match, depending on the condition.
    BooleanRule booleanRule?;
    # A rule that applies a gradient color scale format, based on the interpolation points listed. The format of a cell will vary based on its contents as compared to the values of the interpolation points.
    GradientRule gradientRule?;
    # The ranges that are formatted if the condition is true. All the ranges must be on the same grid.
    GridRange[] ranges?;
};

# The result of deleting a conditional format rule.
public type DeleteConditionalFormatRuleResponse record {
    # A rule describing a conditional format.
    ConditionalFormatRule rule?;
};

# A request to delete developer metadata.
public type DeleteDeveloperMetadataRequest record {
    # Filter that describes what data should be selected or returned from a request.
    DataFilter dataFilter?;
};

# The series of a CandlestickData.
public type CandlestickSeries record {
    # The data included in a domain or series.
    ChartData data?;
};

# The response when clearing a range of values in a spreadsheet.
public type ClearValuesResponse record {
    # The range (in A1 notation) that was cleared. (If the request was for an unbounded range or a ranger larger than the bounds of the sheet, this will be the actual range that was cleared, bounded to the sheet's limits.)
    string clearedRange?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
};

# The response when retrieving more than one range of values in a spreadsheet selected by DataFilters.
public type BatchGetValuesByDataFilterResponse record {
    # The ID of the spreadsheet the data was retrieved from.
    string spreadsheetId?;
    # The requested values with the list of data filters that matched them.
    MatchedValueRange[] valueRanges?;
};

# A filter view.
public type FilterView record {
    # The criteria for showing/hiding values per column. The map's key is the column index, and the value is the criteria for that column. This field is deprecated in favor of filter_specs.
    record {|FilterCriteria...;|} criteria?;
    # The filter criteria for showing/hiding values per column. Both criteria and filter_specs are populated in responses. If both fields are specified in an update request, this field takes precedence.
    FilterSpec[] filterSpecs?;
    # The ID of the filter view.
    int:Signed32 filterViewId?;
    # The named range this filter view is backed by, if any. When writing, only one of range or named_range_id may be set.
    string namedRangeId?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The sort order per column. Later specifications are used when values are equal in the earlier specifications.
    SortSpec[] sortSpecs?;
    # The name of the filter view.
    string title?;
};

# The response when updating a range of values by a data filter in a spreadsheet.
public type UpdateValuesByDataFilterResponse record {
    # Filter that describes what data should be selected or returned from a request.
    DataFilter dataFilter?;
    # The number of cells updated.
    int:Signed32 updatedCells?;
    # The number of columns where at least one cell in the column was updated.
    int:Signed32 updatedColumns?;
    # Data within a range of the spreadsheet.
    GsheetValueRange updatedData?;
    # The range (in [A1 notation](/sheets/api/guides/concepts#cell)) that updates were applied to.
    string updatedRange?;
    # The number of rows where at least one cell in the row was updated.
    int:Signed32 updatedRows?;
};

# A color scale for a treemap chart.
public type TreemapChartColorScale record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color maxValueColor?;
    # A color value.
    ColorStyle maxValueColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color midValueColor?;
    # A color value.
    ColorStyle midValueColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color minValueColor?;
    # A color value.
    ColorStyle minValueColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color noDataColor?;
    # A color value.
    ColorStyle noDataColorStyle?;
};

# Custom number formatting options for chart attributes.
public type ChartCustomNumberFormatOptions record {
    # Custom prefix to be prepended to the chart attribute. This field is optional.
    string prefix?;
    # Custom suffix to be appended to the chart attribute. This field is optional.
    string suffix?;
};

# Inserts data into the spreadsheet starting at the specified coordinate.
public type PasteDataRequest record {
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate coordinate?;
    # The data to insert.
    string data?;
    # The delimiter in the data.
    string delimiter?;
    # True if the data is HTML.
    boolean html?;
    # How the data should be pasted.
    "PASTE_NORMAL"|"PASTE_VALUES"|"PASTE_FORMAT"|"PASTE_NO_BORDERS"|"PASTE_FORMULA"|"PASTE_DATA_VALIDATION"|"PASTE_CONDITIONAL_FORMATTING" 'type?;
};

# The result of adding a filter view.
public type AddFilterViewResponse record {
    # A filter view.
    FilterView filter?;
};

# Information about an external data source in the spreadsheet.
public type DataSource record {
    # All calculated columns in the data source.
    DataSourceColumn[] calculatedColumns?;
    # The spreadsheet-scoped unique ID that identifies the data source. Example: 1080547365.
    string dataSourceId?;
    # The ID of the Sheet connected with the data source. The field cannot be changed once set. When creating a data source, an associated DATA_SOURCE sheet is also created, if the field is not specified, the ID of the created sheet will be randomly generated.
    int:Signed32 sheetId?;
    # This specifies the details of the data source. For example, for BigQuery, this specifies information about the BigQuery source.
    DataSourceSpec spec?;
};

# Duplicates a particular filter view.
public type DuplicateFilterViewRequest record {
    # The ID of the filter being duplicated.
    int:Signed32 filterId?;
};

# Properties referring a single dimension (either row or column). If both BandedRange.row_properties and BandedRange.column_properties are set, the fill colors are applied to cells according to the following rules: * header_color and footer_color take priority over band colors. * first_band_color takes priority over second_band_color. * row_properties takes priority over column_properties. For example, the first row color takes priority over the first column color, but the first column color takes priority over the second row color. Similarly, the row header takes priority over the column header in the top left cell, but the column header takes priority over the first row color if the row header is not set.
public type BandingProperties record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color firstBandColor?;
    # A color value.
    ColorStyle firstBandColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color footerColor?;
    # A color value.
    ColorStyle footerColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color headerColor?;
    # A color value.
    ColorStyle headerColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color secondBandColor?;
    # A color value.
    ColorStyle secondBandColorStyle?;
};

# Allows you to organize the date-time values in a source data column into buckets based on selected parts of their date or time values.
public type ChartDateTimeRule record {
    # The type of date-time grouping to apply.
    "CHART_DATE_TIME_RULE_TYPE_UNSPECIFIED"|"SECOND"|"MINUTE"|"HOUR"|"HOUR_MINUTE"|"HOUR_MINUTE_AMPM"|"DAY_OF_WEEK"|"DAY_OF_YEAR"|"DAY_OF_MONTH"|"DAY_MONTH"|"MONTH"|"QUARTER"|"YEAR"|"YEAR_MONTH"|"YEAR_QUARTER"|"YEAR_MONTH_DAY" 'type?;
};

# The editors of a protected range.
public type Editors record {
    # True if anyone in the document's domain has edit access to the protected range. Domain protection is only supported on documents within a domain.
    boolean domainUsersCanEdit?;
    # The email addresses of groups with edit access to the protected range.
    string[] groups?;
    # The email addresses of users with edit access to the protected range.
    string[] users?;
};

# The execution status of refreshing one data source object.
public type RefreshDataSourceObjectExecutionStatus record {
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # Reference to a data source object.
    DataSourceObjectReference reference?;
};

# Adds a new protected range.
public type AddProtectedRangeRequest record {
    # A protected range.
    ProtectedRange protectedRange?;
};

# Adds a chart to a sheet in the spreadsheet.
public type AddChartRequest record {
    # A chart embedded in a sheet.
    EmbeddedChart chart?;
};

# An external or local reference.
public type Link record {
    # The link identifier.
    string uri?;
};

# Specifies a BigQuery table definition. Only [native tables](https://cloud.google.com/bigquery/docs/tables-intro) is allowed.
public type BigQueryTableSpec record {
    # The BigQuery dataset id.
    string datasetId?;
    # The BigQuery table id.
    string tableId?;
    # The ID of a BigQuery project the table belongs to. If not specified, the project_id is assumed.
    string tableProjectId?;
};

# Updates properties of dimensions within the specified range.
public type UpdateDimensionPropertiesRequest record {
    # A range along a single dimension on a DATA_SOURCE sheet.
    DataSourceSheetDimensionRange dataSourceSheetRange?;
    # The fields that should be updated. At least one field must be specified. The root `properties` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # Properties about a dimension.
    DimensionProperties properties?;
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# Properties that describe the style of a line.
public type LineStyle record {
    # The dash type of the line.
    "LINE_DASH_TYPE_UNSPECIFIED"|"INVISIBLE"|"CUSTOM"|"SOLID"|"DOTTED"|"MEDIUM_DASHED"|"MEDIUM_DASHED_DOTTED"|"LONG_DASHED"|"LONG_DASHED_DOTTED" 'type?;
    # The thickness of the line, in px.
    int:Signed32 width?;
};

# A single series of data for a waterfall chart.
public type WaterfallChartSeries record {
    # Custom subtotal columns appearing in this series. The order in which subtotals are defined is not significant. Only one subtotal may be defined for each data point.
    WaterfallChartCustomSubtotal[] customSubtotals?;
    # The data included in a domain or series.
    ChartData data?;
    # Settings for one set of data labels. Data labels are annotations that appear next to a set of data, such as the points on a line chart, and provide additional information about what the data represents, such as a text representation of the value behind that point on the graph.
    DataLabel dataLabel?;
    # True to hide the subtotal column from the end of the series. By default, a subtotal column will appear at the end of each series. Setting this field to true will hide that subtotal column for this series.
    boolean hideTrailingSubtotal?;
    # Styles for a waterfall chart column.
    WaterfallChartColumnStyle negativeColumnsStyle?;
    # Styles for a waterfall chart column.
    WaterfallChartColumnStyle positiveColumnsStyle?;
    # Styles for a waterfall chart column.
    WaterfallChartColumnStyle subtotalColumnsStyle?;
};

# A location where metadata may be associated in a spreadsheet.
public type DeveloperMetadataLocation record {
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange dimensionRange?;
    # The type of location this object represents. This field is read-only.
    "DEVELOPER_METADATA_LOCATION_TYPE_UNSPECIFIED"|"ROW"|"COLUMN"|"SHEET"|"SPREADSHEET" locationType?;
    # The ID of the sheet when metadata is associated with an entire sheet.
    int:Signed32 sheetId?;
    # True when metadata is associated with an entire spreadsheet.
    boolean spreadsheet?;
};

# Appends rows or columns to the end of a sheet.
public type AppendDimensionRequest record {
    # Whether rows or columns should be appended.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" dimension?;
    # The number of rows or columns to append.
    int:Signed32 length?;
    # The sheet to append rows or columns to.
    int:Signed32 sheetId?;
};

# The response from creating developer metadata.
public type CreateDeveloperMetadataResponse record {
    # Developer metadata associated with a location or object in a spreadsheet. Developer metadata may be used to associate arbitrary data with various parts of a spreadsheet and will remain associated at those locations as they move around and the spreadsheet is edited. For example, if developer metadata is associated with row 5 and another row is then subsequently inserted above row 5, that original metadata will still be associated with the row it was first associated with (what is now row 6). If the associated object is deleted its metadata is deleted too.
    DeveloperMetadata developerMetadata?;
};

# A range of values whose location is specified by a DataFilter.
public type DataFilterValueRange record {
    # Filter that describes what data should be selected or returned from a request.
    DataFilter dataFilter?;
    # The major dimension of the values.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" majorDimension?;
    # The data to be written. If the provided values exceed any of the ranges matched by the data filter then the request fails. If the provided values are less than the matched ranges only the specified values are written, existing values in the matched ranges remain unaffected.
    anydata[][] values?;
};

# Allows you to organize the numeric values in a source data column into buckets of a constant size. All values from HistogramRule.start to HistogramRule.end are placed into groups of size HistogramRule.interval. In addition, all values below HistogramRule.start are placed in one group, and all values above HistogramRule.end are placed in another. Only HistogramRule.interval is required, though if HistogramRule.start and HistogramRule.end are both provided, HistogramRule.start must be less than HistogramRule.end. For example, a pivot table showing average purchase amount by age that has 50+ rows: +-----+-------------------+ | Age | AVERAGE of Amount | +-----+-------------------+ | 16 | $27.13 | | 17 | $5.24 | | 18 | $20.15 | ... +-----+-------------------+ could be turned into a pivot table that looks like the one below by applying a histogram group rule with a HistogramRule.start of 25, an HistogramRule.interval of 20, and an HistogramRule.end of 65. +-------------+-------------------+ | Grouped Age | AVERAGE of Amount | +-------------+-------------------+ | < 25 | $19.34 | | 25-45 | $31.43 | | 45-65 | $35.87 | | > 65 | $27.55 | +-------------+-------------------+ | Grand Total | $29.12 | +-------------+-------------------+
public type HistogramRule record {
    # The maximum value at which items are placed into buckets of constant size. Values above end are lumped into a single bucket. This field is optional.
    decimal end?;
    # The size of the buckets that are created. Must be positive.
    decimal interval?;
    # The minimum value at which items are placed into buckets of constant size. Values below start are lumped into a single bucket. This field is optional.
    decimal 'start?;
};

# Deletes a particular filter view.
public type DeleteFilterViewRequest record {
    # The ID of the filter to delete.
    int:Signed32 filterId?;
};

# A column in a data source.
public type DataSourceColumn record {
    # The formula of the calculated column.
    string formula?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference reference?;
};

# Copies data from the source to the destination.
public type CopyPasteRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange destination?;
    # How that data should be oriented when pasting.
    "NORMAL"|"TRANSPOSE" pasteOrientation?;
    # What kind of data to paste.
    "PASTE_NORMAL"|"PASTE_VALUES"|"PASTE_FORMAT"|"PASTE_NO_BORDERS"|"PASTE_FORMULA"|"PASTE_DATA_VALIDATION"|"PASTE_CONDITIONAL_FORMATTING" pasteType?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange 'source?;
};

# A condition that can evaluate to true or false. BooleanConditions are used by conditional formatting, data validation, and the criteria in filters.
public type BooleanCondition record {
    # The type of condition.
    "CONDITION_TYPE_UNSPECIFIED"|"NUMBER_GREATER"|"NUMBER_GREATER_THAN_EQ"|"NUMBER_LESS"|"NUMBER_LESS_THAN_EQ"|"NUMBER_EQ"|"NUMBER_NOT_EQ"|"NUMBER_BETWEEN"|"NUMBER_NOT_BETWEEN"|"TEXT_CONTAINS"|"TEXT_NOT_CONTAINS"|"TEXT_STARTS_WITH"|"TEXT_ENDS_WITH"|"TEXT_EQ"|"TEXT_IS_EMAIL"|"TEXT_IS_URL"|"DATE_EQ"|"DATE_BEFORE"|"DATE_AFTER"|"DATE_ON_OR_BEFORE"|"DATE_ON_OR_AFTER"|"DATE_BETWEEN"|"DATE_NOT_BETWEEN"|"DATE_IS_VALID"|"ONE_OF_RANGE"|"ONE_OF_LIST"|"BLANK"|"NOT_BLANK"|"CUSTOM_FORMULA"|"BOOLEAN"|"TEXT_NOT_EQ"|"DATE_NOT_EQ"|"FILTER_EXPRESSION" 'type?;
    # The values of the condition. The number of supported values depends on the condition type. Some support zero values, others one or two values, and ConditionType.ONE_OF_LIST supports an arbitrary number of values.
    ConditionValue[] values?;
};

# A single series of data in a chart. For example, if charting stock prices over time, multiple series may exist, one for the "Open Price", "High Price", "Low Price" and "Close Price".
public type BasicChartSeries record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
    # Settings for one set of data labels. Data labels are annotations that appear next to a set of data, such as the points on a line chart, and provide additional information about what the data represents, such as a text representation of the value behind that point on the graph.
    DataLabel dataLabel?;
    # Properties that describe the style of a line.
    LineStyle lineStyle?;
    # The style of a point on the chart.
    PointStyle pointStyle?;
    # The data included in a domain or series.
    ChartData series?;
    # Style override settings for series data points.
    BasicSeriesDataPointStyleOverride[] styleOverrides?;
    # The minor axis that will specify the range of values for this series. For example, if charting stocks over time, the "Volume" series may want to be pinned to the right with the prices pinned to the left, because the scale of trading volume is different than the scale of prices. It is an error to specify an axis that isn't a valid minor axis for the chart's type.
    "BASIC_CHART_AXIS_POSITION_UNSPECIFIED"|"BOTTOM_AXIS"|"LEFT_AXIS"|"RIGHT_AXIS" targetAxis?;
    # The type of this series. Valid only if the chartType is COMBO. Different types will change the way the series is visualized. Only LINE, AREA, and COLUMN are supported.
    "BASIC_CHART_TYPE_UNSPECIFIED"|"BAR"|"LINE"|"AREA"|"COLUMN"|"SCATTER"|"COMBO"|"STEPPED_AREA" 'type?;
};

# The result of adding a group.
public type AddDimensionGroupResponse record {
    # All groups of a dimension after adding a group to that dimension.
    DimensionGroup[] dimensionGroups?;
};

# A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
public type GridRange record {
    # The end column (exclusive) of the range, or not set if unbounded.
    int:Signed32 endColumnIndex?;
    # The end row (exclusive) of the range, or not set if unbounded.
    int:Signed32 endRowIndex?;
    # The sheet this range is on.
    int:Signed32 sheetId?;
    # The start column (inclusive) of the range, or not set if unbounded.
    int:Signed32 startColumnIndex?;
    # The start row (inclusive) of the range, or not set if unbounded.
    int:Signed32 startRowIndex?;
};

# An optional setting on a PivotGroup that defines buckets for the values in the source data column rather than breaking out each individual value. Only one PivotGroup with a group rule may be added for each column in the source data, though on any given column you may add both a PivotGroup that has a rule and a PivotGroup that does not.
public type PivotGroupRule record {
    # Allows you to organize the date-time values in a source data column into buckets based on selected parts of their date or time values. For example, consider a pivot table showing sales transactions by date: +----------+--------------+ | Date | SUM of Sales | +----------+--------------+ | 1/1/2017 | $621.14 | | 2/3/2017 | $708.84 | | 5/8/2017 | $326.84 | ... +----------+--------------+ Applying a date-time group rule with a DateTimeRuleType of YEAR_MONTH results in the following pivot table. +--------------+--------------+ | Grouped Date | SUM of Sales | +--------------+--------------+ | 2017-Jan | $53,731.78 | | 2017-Feb | $83,475.32 | | 2017-Mar | $94,385.05 | ... +--------------+--------------+
    DateTimeRule dateTimeRule?;
    # Allows you to organize the numeric values in a source data column into buckets of a constant size. All values from HistogramRule.start to HistogramRule.end are placed into groups of size HistogramRule.interval. In addition, all values below HistogramRule.start are placed in one group, and all values above HistogramRule.end are placed in another. Only HistogramRule.interval is required, though if HistogramRule.start and HistogramRule.end are both provided, HistogramRule.start must be less than HistogramRule.end. For example, a pivot table showing average purchase amount by age that has 50+ rows: +-----+-------------------+ | Age | AVERAGE of Amount | +-----+-------------------+ | 16 | $27.13 | | 17 | $5.24 | | 18 | $20.15 | ... +-----+-------------------+ could be turned into a pivot table that looks like the one below by applying a histogram group rule with a HistogramRule.start of 25, an HistogramRule.interval of 20, and an HistogramRule.end of 65. +-------------+-------------------+ | Grouped Age | AVERAGE of Amount | +-------------+-------------------+ | < 25 | $19.34 | | 25-45 | $31.43 | | 45-65 | $35.87 | | > 65 | $27.55 | +-------------+-------------------+ | Grand Total | $29.12 | +-------------+-------------------+
    HistogramRule histogramRule?;
    # Allows you to manually organize the values in a source data column into buckets with names of your choosing. For example, a pivot table that aggregates population by state: +-------+-------------------+ | State | SUM of Population | +-------+-------------------+ | AK | 0.7 | | AL | 4.8 | | AR | 2.9 | ... +-------+-------------------+ could be turned into a pivot table that aggregates population by time zone by providing a list of groups (for example, groupName = 'Central', items = ['AL', 'AR', 'IA', ...]) to a manual group rule. Note that a similar effect could be achieved by adding a time zone column to the source data and adjusting the pivot table. +-----------+-------------------+ | Time Zone | SUM of Population | +-----------+-------------------+ | Central | 106.3 | | Eastern | 151.9 | | Mountain | 17.4 | ... +-----------+-------------------+
    ManualRule manualRule?;
};

# The response when updating a range of values in a spreadsheet.
public type BatchUpdateValuesResponse record {
    # One UpdateValuesResponse per requested range, in the same order as the requests appeared.
    UpdateValuesResponse[] responses?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
    # The total number of cells updated.
    int:Signed32 totalUpdatedCells?;
    # The total number of columns where at least one cell in the column was updated.
    int:Signed32 totalUpdatedColumns?;
    # The total number of rows where at least one cell in the row was updated.
    int:Signed32 totalUpdatedRows?;
    # The total number of sheets where at least one cell in the sheet was updated.
    int:Signed32 totalUpdatedSheets?;
};

# Updates properties of the named range with the specified namedRangeId.
public type UpdateNamedRangeRequest record {
    # The fields that should be updated. At least one field must be specified. The root `namedRange` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # A named range.
    NamedRange namedRange?;
};

# The specification of a BigQuery data source that's connected to a sheet.
public type BigQueryDataSourceSpec record {
    # The ID of a BigQuery enabled GCP project with a billing account attached. For any queries executed against the data source, the project is charged.
    string projectId?;
    # Specifies a custom BigQuery query.
    BigQueryQuerySpec querySpec?;
    # Specifies a BigQuery table definition. Only [native tables](https://cloud.google.com/bigquery/docs/tables-intro) is allowed.
    BigQueryTableSpec tableSpec?;
};

# A list of references to data source objects.
public type DataSourceObjectReferences record {
    # The references.
    DataSourceObjectReference[] references?;
};

# A sort order associated with a specific column or row.
public type SortSpec record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color backgroundColor?;
    # A color value.
    ColorStyle backgroundColorStyle?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # The dimension the sort should be applied to.
    int:Signed32 dimensionIndex?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color foregroundColor?;
    # A color value.
    ColorStyle foregroundColorStyle?;
    # The order data should be sorted.
    "SORT_ORDER_UNSPECIFIED"|"ASCENDING"|"DESCENDING" sortOrder?;
};

# The default filter associated with a sheet.
public type BasicFilter record {
    # The criteria for showing/hiding values per column. The map's key is the column index, and the value is the criteria for that column. This field is deprecated in favor of filter_specs.
    record {|FilterCriteria...;|} criteria?;
    # The filter criteria per column. Both criteria and filter_specs are populated in responses. If both fields are specified in an update request, this field takes precedence.
    FilterSpec[] filterSpecs?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The sort order per column. Later specifications are used when values are equal in the earlier specifications.
    SortSpec[] sortSpecs?;
};

# Deletes the requested sheet.
public type DeleteSheetRequest record {
    # The ID of the sheet to delete. If the sheet is of DATA_SOURCE type, the associated DataSource is also deleted.
    int:Signed32 sheetId?;
};

# Styles for a waterfall chart column.
public type WaterfallChartColumnStyle record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
    # The label of the column's legend.
    string label?;
};

# A slicer in a sheet.
public type Slicer record {
    # The position of an embedded object such as a chart.
    EmbeddedObjectPosition position?;
    # The ID of the slicer.
    int:Signed32 slicerId?;
    # The specifications of a slicer.
    SlicerSpec spec?;
};

# The response from updating data source.
public type UpdateDataSourceResponse record {
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # Information about an external data source in the spreadsheet.
    DataSource dataSource?;
};

# A request to retrieve all developer metadata matching the set of specified criteria.
public type SearchDeveloperMetadataRequest record {
    # The data filters describing the criteria used to determine which DeveloperMetadata entries to return. DeveloperMetadata matching any of the specified filters are included in the response.
    DataFilter[] dataFilters?;
};

# The result of adding a data source.
public type AddDataSourceResponse record {
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # Information about an external data source in the spreadsheet.
    DataSource dataSource?;
};

# Source ranges for a chart.
public type ChartSourceRange record {
    # The ranges of data for a series or domain. Exactly one dimension must have a length of 1, and all sources in the list must have the same dimension with length 1. The domain (if it exists) & all series must have the same number of source ranges. If using more than one source range, then the source range at a given offset must be in order and contiguous across the domain and series. For example, these are valid configurations: domain sources: A1:A5 series1 sources: B1:B5 series2 sources: D6:D10 domain sources: A1:A5, C10:C12 series1 sources: B1:B5, D10:D12 series2 sources: C1:C5, E10:E12
    GridRange[] sources?;
};

# The rotation applied to text in a cell.
public type TextRotation record {
    # The angle between the standard orientation and the desired orientation. Measured in degrees. Valid values are between -90 and 90. Positive angles are angled upwards, negative are angled downwards. Note: For LTR text direction positive angles are in the counterclockwise direction, whereas for RTL they are in the clockwise direction
    int:Signed32 angle?;
    # If true, text reads top to bottom, but the orientation of individual characters is unchanged. For example: | V | | e | | r | | t | | i | | c | | a | | l |
    boolean vertical?;
};

# The request for clearing more than one range of values in a spreadsheet.
public type BatchClearValuesRequest record {
    # The ranges to clear, in [A1 notation or R1C1 notation](/sheets/api/guides/concepts#cell).
    string[] ranges?;
};

# Properties of a grid.
public type GridProperties record {
    # The number of columns in the grid.
    int:Signed32 columnCount?;
    # True if the column grouping control toggle is shown after the group.
    boolean columnGroupControlAfter?;
    # The number of columns that are frozen in the grid.
    int:Signed32 frozenColumnCount?;
    # The number of rows that are frozen in the grid.
    int:Signed32 frozenRowCount?;
    # True if the grid isn't showing gridlines in the UI.
    boolean hideGridlines?;
    # The number of rows in the grid.
    int:Signed32 rowCount?;
    # True if the row grouping control toggle is shown after the group.
    boolean rowGroupControlAfter?;
};

# Deletes a conditional format rule at the given index. All subsequent rules' indexes are decremented.
public type DeleteConditionalFormatRuleRequest record {
    # The zero-based index of the rule to be deleted.
    int:Signed32 index?;
    # The sheet the rule is being deleted from.
    int:Signed32 sheetId?;
};

# A histogram chart. A histogram chart groups data items into bins, displaying each bin as a column of stacked items. Histograms are used to display the distribution of a dataset. Each column of items represents a range into which those items fall. The number of bins can be chosen automatically or specified explicitly.
public type HistogramChartSpec record {
    # By default the bucket size (the range of values stacked in a single column) is chosen automatically, but it may be overridden here. E.g., A bucket size of 1.5 results in buckets from 0 - 1.5, 1.5 - 3.0, etc. Cannot be negative. This field is optional.
    decimal bucketSize?;
    # The position of the chart legend.
    "HISTOGRAM_CHART_LEGEND_POSITION_UNSPECIFIED"|"BOTTOM_LEGEND"|"LEFT_LEGEND"|"RIGHT_LEGEND"|"TOP_LEGEND"|"NO_LEGEND"|"INSIDE_LEGEND" legendPosition?;
    # The outlier percentile is used to ensure that outliers do not adversely affect the calculation of bucket sizes. For example, setting an outlier percentile of 0.05 indicates that the top and bottom 5% of values when calculating buckets. The values are still included in the chart, they will be added to the first or last buckets instead of their own buckets. Must be between 0.0 and 0.5.
    decimal outlierPercentile?;
    # The series for a histogram may be either a single series of values to be bucketed or multiple series, each of the same length, containing the name of the series followed by the values to be bucketed for that series.
    HistogramSeries[] series?;
    # Whether horizontal divider lines should be displayed between items in each column.
    boolean showItemDividers?;
};

# The domain of a CandlestickChart.
public type CandlestickDomain record {
    # The data included in a domain or series.
    ChartData data?;
    # True to reverse the order of the domain values (horizontal axis).
    boolean reversed?;
};

# The borders of the cell.
public type Borders record {
    # A border along a cell.
    Border bottom?;
    # A border along a cell.
    Border left?;
    # A border along a cell.
    Border right?;
    # A border along a cell.
    Border top?;
};

# Selects DeveloperMetadata that matches all of the specified fields. For example, if only a metadata ID is specified this considers the DeveloperMetadata with that particular unique ID. If a metadata key is specified, this considers all developer metadata with that key. If a key, visibility, and location type are all specified, this considers all developer metadata with that key and visibility that are associated with a location of that type. In general, this selects all DeveloperMetadata that matches the intersection of all the specified fields; any field or combination of fields may be specified.
public type DeveloperMetadataLookup record {
    # Determines how this lookup matches the location. If this field is specified as EXACT, only developer metadata associated on the exact location specified is matched. If this field is specified to INTERSECTING, developer metadata associated on intersecting locations is also matched. If left unspecified, this field assumes a default value of INTERSECTING. If this field is specified, a metadataLocation must also be specified.
    "DEVELOPER_METADATA_LOCATION_MATCHING_STRATEGY_UNSPECIFIED"|"EXACT_LOCATION"|"INTERSECTING_LOCATION" locationMatchingStrategy?;
    # Limits the selected developer metadata to those entries which are associated with locations of the specified type. For example, when this field is specified as ROW this lookup only considers developer metadata associated on rows. If the field is left unspecified, all location types are considered. This field cannot be specified as SPREADSHEET when the locationMatchingStrategy is specified as INTERSECTING or when the metadataLocation is specified as a non-spreadsheet location: spreadsheet metadata cannot intersect any other developer metadata location. This field also must be left unspecified when the locationMatchingStrategy is specified as EXACT.
    "DEVELOPER_METADATA_LOCATION_TYPE_UNSPECIFIED"|"ROW"|"COLUMN"|"SHEET"|"SPREADSHEET" locationType?;
    # Limits the selected developer metadata to that which has a matching DeveloperMetadata.metadata_id.
    int:Signed32 metadataId?;
    # Limits the selected developer metadata to that which has a matching DeveloperMetadata.metadata_key.
    string metadataKey?;
    # A location where metadata may be associated in a spreadsheet.
    DeveloperMetadataLocation metadataLocation?;
    # Limits the selected developer metadata to that which has a matching DeveloperMetadata.metadata_value.
    string metadataValue?;
    # Limits the selected developer metadata to that which has a matching DeveloperMetadata.visibility. If left unspecified, all developer metadata visibile to the requesting project is considered.
    "DEVELOPER_METADATA_VISIBILITY_UNSPECIFIED"|"DOCUMENT"|"PROJECT" visibility?;
};

# Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
public type Color record {
    # The fraction of this color that should be applied to the pixel. That is, the final pixel color is defined by the equation: `pixel color = alpha * (this color) + (1.0 - alpha) * (background color)` This means that a value of 1.0 corresponds to a solid color, whereas a value of 0.0 corresponds to a completely transparent color. This uses a wrapper message rather than a simple float scalar so that it is possible to distinguish between a default value and the value being unset. If omitted, this color object is rendered as a solid color (as if the alpha value had been explicitly given a value of 1.0).
    float alpha?;
    # The amount of blue in the color as a value in the interval [0, 1].
    float blue?;
    # The amount of green in the color as a value in the interval [0, 1].
    float green?;
    # The amount of red in the color as a value in the interval [0, 1].
    float red?;
};

# The response when updating a range of values in a spreadsheet.
public type BatchUpdateValuesByDataFilterResponse record {
    # The response for each range updated.
    UpdateValuesByDataFilterResponse[] responses?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
    # The total number of cells updated.
    int:Signed32 totalUpdatedCells?;
    # The total number of columns where at least one cell in the column was updated.
    int:Signed32 totalUpdatedColumns?;
    # The total number of rows where at least one cell in the row was updated.
    int:Signed32 totalUpdatedRows?;
    # The total number of sheets where at least one cell in the sheet was updated.
    int:Signed32 totalUpdatedSheets?;
};

# Updates properties of the filter view.
public type UpdateFilterViewRequest record {
    # The fields that should be updated. At least one field must be specified. The root `filter` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # A filter view.
    FilterView filter?;
};

# Deletes the dimensions from the sheet.
public type DeleteDimensionRequest record {
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# The request for clearing a range of values in a spreadsheet.
public type ClearValuesRequest record {
};

# The result of removing duplicates in a range.
public type DeleteDuplicatesResponse record {
    # The number of duplicate rows removed.
    int:Signed32 duplicatesRemovedCount?;
};

# Updates a data source. After the data source is updated successfully, an execution is triggered to refresh the associated DATA_SOURCE sheet to read data from the updated data source. The request requires an additional `bigquery.readonly` OAuth scope.
public type UpdateDataSourceRequest record {
    # Information about an external data source in the spreadsheet.
    DataSource dataSource?;
    # The fields that should be updated. At least one field must be specified. The root `dataSource` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
};

# A protected range.
public type ProtectedRange record {
    # The description of this protected range.
    string description?;
    # The editors of a protected range.
    Editors editors?;
    # The named range this protected range is backed by, if any. When writing, only one of range or named_range_id may be set.
    string namedRangeId?;
    # The ID of the protected range. This field is read-only.
    int:Signed32 protectedRangeId?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # True if the user who requested this protected range can edit the protected area. This field is read-only.
    boolean requestingUserCanEdit?;
    # The list of unprotected ranges within a protected sheet. Unprotected ranges are only supported on protected sheets.
    GridRange[] unprotectedRanges?;
    # True if this protected range will show a warning when editing. Warning-based protection means that every user can edit data in the protected range, except editing will prompt a warning asking the user to confirm the edit. When writing: if this field is true, then editors is ignored. Additionally, if this field is changed from true to false and the `editors` field is not set (nor included in the field mask), then the editors will be set to all the editors in the document.
    boolean warningOnly?;
};

# A border along a cell.
public type Border record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
    # The style of the border.
    "STYLE_UNSPECIFIED"|"DOTTED"|"DASHED"|"SOLID"|"SOLID_MEDIUM"|"SOLID_THICK"|"NONE"|"DOUBLE" style?;
    # The width of the border, in pixels. Deprecated; the width is determined by the "style" field.
    int:Signed32 width?;
};

# An org chart. Org charts require a unique set of labels in labels and may optionally include parent_labels and tooltips. parent_labels contain, for each node, the label identifying the parent node. tooltips contain, for each node, an optional tooltip. For example, to describe an OrgChart with Alice as the CEO, Bob as the President (reporting to Alice) and Cathy as VP of Sales (also reporting to Alice), have labels contain "Alice", "Bob", "Cathy", parent_labels contain "", "Alice", "Alice" and tooltips contain "CEO", "President", "VP Sales".
public type OrgChartSpec record {
    # The data included in a domain or series.
    ChartData labels?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color nodeColor?;
    # A color value.
    ColorStyle nodeColorStyle?;
    # The size of the org chart nodes.
    "ORG_CHART_LABEL_SIZE_UNSPECIFIED"|"SMALL"|"MEDIUM"|"LARGE" nodeSize?;
    # The data included in a domain or series.
    ChartData parentLabels?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color selectedNodeColor?;
    # A color value.
    ColorStyle selectedNodeColorStyle?;
    # The data included in a domain or series.
    ChartData tooltips?;
};

# Allows you to organize numeric values in a source data column into buckets of constant size.
public type ChartHistogramRule record {
    # The size of the buckets that are created. Must be positive.
    decimal intervalSize?;
    # The maximum value at which items are placed into buckets. Values greater than the maximum are grouped into a single bucket. If omitted, it is determined by the maximum item value.
    decimal maxValue?;
    # The minimum value at which items are placed into buckets. Values that are less than the minimum are grouped into a single bucket. If omitted, it is determined by the minimum item value.
    decimal minValue?;
};

# Updates all cells in the range to the values in the given Cell object. Only the fields listed in the fields field are updated; others are unchanged. If writing a cell with a formula, the formula's ranges will automatically increment for each field in the range. For example, if writing a cell with formula `=A1` into range B2:C4, B2 would be `=A1`, B3 would be `=A2`, B4 would be `=A3`, C2 would be `=B1`, C3 would be `=B2`, C4 would be `=B3`. To keep the formula's ranges static, use the `$` indicator. For example, use the formula `=$A$1` to prevent both the row and the column from incrementing.
public type RepeatCellRequest record {
    # Data about a specific cell.
    CellData cell?;
    # The fields that should be updated. At least one field must be specified. The root `cell` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# The specifications of a slicer.
public type SlicerSpec record {
    # True if the filter should apply to pivot tables. If not set, default to `True`.
    boolean applyToPivotTables?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color backgroundColor?;
    # A color value.
    ColorStyle backgroundColorStyle?;
    # The column index in the data table on which the filter is applied to.
    int:Signed32 columnIndex?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange dataRange?;
    # Criteria for showing/hiding rows in a filter or filter view.
    FilterCriteria filterCriteria?;
    # The horizontal alignment of title in the slicer. If unspecified, defaults to `LEFT`
    "HORIZONTAL_ALIGN_UNSPECIFIED"|"LEFT"|"CENTER"|"RIGHT" horizontalAlignment?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
    # The title of the slicer.
    string title?;
};

# The request for updating any aspect of a spreadsheet.
public type BatchUpdateSpreadsheetRequest record {
    # Determines if the update response should include the spreadsheet resource.
    boolean includeSpreadsheetInResponse?;
    # A list of updates to apply to the spreadsheet. Requests will be applied in the order they are specified. If any request is not valid, no requests will be applied.
    Request[] requests?;
    # True if grid data should be returned. Meaningful only if include_spreadsheet_in_response is 'true'. This parameter is ignored if a field mask was set in the request.
    boolean responseIncludeGridData?;
    # Limits the ranges included in the response spreadsheet. Meaningful only if include_spreadsheet_in_response is 'true'.
    string[] responseRanges?;
};

# Creates a group over the specified range. If the requested range is a superset of the range of an existing group G, then the depth of G is incremented and this new group G' has the depth of that group. For example, a group [C:D, depth 1] + [B:E] results in groups [B:E, depth 1] and [C:D, depth 2]. If the requested range is a subset of the range of an existing group G, then the depth of the new group G' becomes one greater than the depth of G. For example, a group [B:E, depth 1] + [C:D] results in groups [B:E, depth 1] and [C:D, depth 2]. If the requested range starts before and ends within, or starts within and ends after, the range of an existing group G, then the range of the existing group G becomes the union of the ranges, and the new group G' has depth one greater than the depth of G and range as the intersection of the ranges. For example, a group [B:D, depth 1] + [C:E] results in groups [B:E, depth 1] and [C:D, depth 2].
public type AddDimensionGroupRequest record {
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# Updates the borders of a range. If a field is not set in the request, that means the border remains as-is. For example, with two subsequent UpdateBordersRequest: 1. range: A1:A5 `{ top: RED, bottom: WHITE }` 2. range: A1:A5 `{ left: BLUE }` That would result in A1:A5 having a borders of `{ top: RED, bottom: WHITE, left: BLUE }`. If you want to clear a border, explicitly set the style to NONE.
public type UpdateBordersRequest record {
    # A border along a cell.
    Border bottom?;
    # A border along a cell.
    Border innerHorizontal?;
    # A border along a cell.
    Border innerVertical?;
    # A border along a cell.
    Border left?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # A border along a cell.
    Border right?;
    # A border along a cell.
    Border top?;
};

# Updates a conditional format rule at the given index, or moves a conditional format rule to another index.
public type UpdateConditionalFormatRuleRequest record {
    # The zero-based index of the rule that should be replaced or moved.
    int:Signed32 index?;
    # The zero-based new index the rule should end up at.
    int:Signed32 newIndex?;
    # A rule describing a conditional format.
    ConditionalFormatRule rule?;
    # The sheet of the rule to move. Required if new_index is set, unused otherwise.
    int:Signed32 sheetId?;
};

# Adds a new banded range to the spreadsheet.
public type AddBandingRequest record {
    # A banded (alternating colors) range in a sheet.
    BandedRange bandedRange?;
};

# Removes the named range with the given ID from the spreadsheet.
public type DeleteNamedRangeRequest record {
    # The ID of the named range to delete.
    string namedRangeId?;
};

# The amount of padding around the cell, in pixels. When updating padding, every field must be specified.
public type Padding record {
    # The bottom padding of the cell.
    int:Signed32 bottom?;
    # The left padding of the cell.
    int:Signed32 left?;
    # The right padding of the cell.
    int:Signed32 right?;
    # The top padding of the cell.
    int:Signed32 top?;
};

# A monthly schedule for data to refresh on specific days in the month in a given time interval.
public type DataSourceRefreshMonthlySchedule record {
    # Days of the month to refresh. Only 1-28 are supported, mapping to the 1st to the 28th day. At lesat one day must be specified.
    int:Signed32[] daysOfMonth?;
    # Represents a time of day. The date and time zone are either not significant or are specified elsewhere. An API may choose to allow leap seconds. Related types are google.type.Date and `google.protobuf.Timestamp`.
    TimeOfDay startTime?;
};

# An unique identifier that references a data source column.
public type DataSourceColumnReference record {
    # The display name of the column. It should be unique within a data source.
    string name?;
};

# Updates an existing protected range with the specified protectedRangeId.
public type UpdateProtectedRangeRequest record {
    # The fields that should be updated. At least one field must be specified. The root `protectedRange` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # A protected range.
    ProtectedRange protectedRange?;
};

# Sorts data in rows based on a sort order per column.
public type SortRangeRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The sort order per column. Later specifications are used when values are equal in the earlier specifications.
    SortSpec[] sortSpecs?;
};

# The request for clearing more than one range selected by a DataFilter in a spreadsheet.
public type BatchClearValuesByDataFilterRequest record {
    # The DataFilters used to determine which ranges to clear.
    DataFilter[] dataFilters?;
};

# The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
public type DataExecutionStatus record {
    # The error code.
    "DATA_EXECUTION_ERROR_CODE_UNSPECIFIED"|"TIMED_OUT"|"TOO_MANY_ROWS"|"TOO_MANY_COLUMNS"|"TOO_MANY_CELLS"|"ENGINE"|"PARAMETER_INVALID"|"UNSUPPORTED_DATA_TYPE"|"DUPLICATE_COLUMN_NAMES"|"INTERRUPTED"|"CONCURRENT_QUERY"|"OTHER"|"TOO_MANY_CHARS_PER_CELL"|"DATA_NOT_FOUND"|"PERMISSION_DENIED"|"MISSING_COLUMN_ALIAS"|"OBJECT_NOT_FOUND"|"OBJECT_IN_ERROR_STATE"|"OBJECT_SPEC_INVALID" errorCode?;
    # The error message, which may be empty.
    string errorMessage?;
    # Gets the time the data last successfully refreshed.
    string lastRefreshTime?;
    # The state of the data execution.
    "DATA_EXECUTION_STATE_UNSPECIFIED"|"NOT_STARTED"|"RUNNING"|"SUCCEEDED"|"FAILED" state?;
};

# A single kind of update to apply to a spreadsheet.
public type Request record {
    # Adds a new banded range to the spreadsheet.
    AddBandingRequest addBanding?;
    # Adds a chart to a sheet in the spreadsheet.
    AddChartRequest addChart?;
    # Adds a new conditional format rule at the given index. All subsequent rules' indexes are incremented.
    AddConditionalFormatRuleRequest addConditionalFormatRule?;
    # Adds a data source. After the data source is added successfully, an associated DATA_SOURCE sheet is created and an execution is triggered to refresh the sheet to read data from the data source. The request requires an additional `bigquery.readonly` OAuth scope.
    AddDataSourceRequest addDataSource?;
    # Creates a group over the specified range. If the requested range is a superset of the range of an existing group G, then the depth of G is incremented and this new group G' has the depth of that group. For example, a group [C:D, depth 1] + [B:E] results in groups [B:E, depth 1] and [C:D, depth 2]. If the requested range is a subset of the range of an existing group G, then the depth of the new group G' becomes one greater than the depth of G. For example, a group [B:E, depth 1] + [C:D] results in groups [B:E, depth 1] and [C:D, depth 2]. If the requested range starts before and ends within, or starts within and ends after, the range of an existing group G, then the range of the existing group G becomes the union of the ranges, and the new group G' has depth one greater than the depth of G and range as the intersection of the ranges. For example, a group [B:D, depth 1] + [C:E] results in groups [B:E, depth 1] and [C:D, depth 2].
    AddDimensionGroupRequest addDimensionGroup?;
    # Adds a filter view.
    AddFilterViewRequest addFilterView?;
    # Adds a named range to the spreadsheet.
    AddNamedRangeRequest addNamedRange?;
    # Adds a new protected range.
    AddProtectedRangeRequest addProtectedRange?;
    # Adds a new sheet. When a sheet is added at a given index, all subsequent sheets' indexes are incremented. To add an object sheet, use AddChartRequest instead and specify EmbeddedObjectPosition.sheetId or EmbeddedObjectPosition.newSheet.
    AddSheetRequest addSheet?;
    # Adds a slicer to a sheet in the spreadsheet.
    AddSlicerRequest addSlicer?;
    # Adds new cells after the last row with data in a sheet, inserting new rows into the sheet if necessary.
    AppendCellsRequest appendCells?;
    # Appends rows or columns to the end of a sheet.
    AppendDimensionRequest appendDimension?;
    # Fills in more data based on existing data.
    AutoFillRequest autoFill?;
    # Automatically resizes one or more dimensions based on the contents of the cells in that dimension.
    AutoResizeDimensionsRequest autoResizeDimensions?;
    # Clears the basic filter, if any exists on the sheet.
    ClearBasicFilterRequest clearBasicFilter?;
    # Copies data from the source to the destination.
    CopyPasteRequest copyPaste?;
    # A request to create developer metadata.
    CreateDeveloperMetadataRequest createDeveloperMetadata?;
    # Moves data from the source to the destination.
    CutPasteRequest cutPaste?;
    # Removes the banded range with the given ID from the spreadsheet.
    DeleteBandingRequest deleteBanding?;
    # Deletes a conditional format rule at the given index. All subsequent rules' indexes are decremented.
    DeleteConditionalFormatRuleRequest deleteConditionalFormatRule?;
    # Deletes a data source. The request also deletes the associated data source sheet, and unlinks all associated data source objects.
    DeleteDataSourceRequest deleteDataSource?;
    # A request to delete developer metadata.
    DeleteDeveloperMetadataRequest deleteDeveloperMetadata?;
    # Deletes the dimensions from the sheet.
    DeleteDimensionRequest deleteDimension?;
    # Deletes a group over the specified range by decrementing the depth of the dimensions in the range. For example, assume the sheet has a depth-1 group over B:E and a depth-2 group over C:D. Deleting a group over D:E leaves the sheet with a depth-1 group over B:D and a depth-2 group over C:C.
    DeleteDimensionGroupRequest deleteDimensionGroup?;
    # Removes rows within this range that contain values in the specified columns that are duplicates of values in any previous row. Rows with identical values but different letter cases, formatting, or formulas are considered to be duplicates. This request also removes duplicate rows hidden from view (for example, due to a filter). When removing duplicates, the first instance of each duplicate row scanning from the top downwards is kept in the resulting range. Content outside of the specified range isn't removed, and rows considered duplicates do not have to be adjacent to each other in the range.
    DeleteDuplicatesRequest deleteDuplicates?;
    # Deletes the embedded object with the given ID.
    DeleteEmbeddedObjectRequest deleteEmbeddedObject?;
    # Deletes a particular filter view.
    DeleteFilterViewRequest deleteFilterView?;
    # Removes the named range with the given ID from the spreadsheet.
    DeleteNamedRangeRequest deleteNamedRange?;
    # Deletes the protected range with the given ID.
    DeleteProtectedRangeRequest deleteProtectedRange?;
    # Deletes a range of cells, shifting other cells into the deleted area.
    DeleteRangeRequest deleteRange?;
    # Deletes the requested sheet.
    DeleteSheetRequest deleteSheet?;
    # Duplicates a particular filter view.
    DuplicateFilterViewRequest duplicateFilterView?;
    # Duplicates the contents of a sheet.
    DuplicateSheetRequest duplicateSheet?;
    # Finds and replaces data in cells over a range, sheet, or all sheets.
    FindReplaceRequest findReplace?;
    # Inserts rows or columns in a sheet at a particular index.
    InsertDimensionRequest insertDimension?;
    # Inserts cells into a range, shifting the existing cells over or down.
    InsertRangeRequest insertRange?;
    # Merges all cells in the range.
    MergeCellsRequest mergeCells?;
    # Moves one or more rows or columns.
    MoveDimensionRequest moveDimension?;
    # Inserts data into the spreadsheet starting at the specified coordinate.
    PasteDataRequest pasteData?;
    # Randomizes the order of the rows in a range.
    RandomizeRangeRequest randomizeRange?;
    # Refreshes one or multiple data source objects in the spreadsheet by the specified references. The request requires an additional `bigquery.readonly` OAuth scope. If there are multiple refresh requests referencing the same data source objects in one batch, only the last refresh request is processed, and all those requests will have the same response accordingly.
    RefreshDataSourceRequest refreshDataSource?;
    # Updates all cells in the range to the values in the given Cell object. Only the fields listed in the fields field are updated; others are unchanged. If writing a cell with a formula, the formula's ranges will automatically increment for each field in the range. For example, if writing a cell with formula `=A1` into range B2:C4, B2 would be `=A1`, B3 would be `=A2`, B4 would be `=A3`, C2 would be `=B1`, C3 would be `=B2`, C4 would be `=B3`. To keep the formula's ranges static, use the `$` indicator. For example, use the formula `=$A$1` to prevent both the row and the column from incrementing.
    RepeatCellRequest repeatCell?;
    # Sets the basic filter associated with a sheet.
    SetBasicFilterRequest setBasicFilter?;
    # Sets a data validation rule to every cell in the range. To clear validation in a range, call this with no rule specified.
    SetDataValidationRequest setDataValidation?;
    # Sorts data in rows based on a sort order per column.
    SortRangeRequest sortRange?;
    # Splits a column of text into multiple columns, based on a delimiter in each cell.
    TextToColumnsRequest textToColumns?;
    # Trims the whitespace (such as spaces, tabs, or new lines) in every cell in the specified range. This request removes all whitespace from the start and end of each cell's text, and reduces any subsequence of remaining whitespace characters to a single space. If the resulting trimmed text starts with a '+' or '=' character, the text remains as a string value and isn't interpreted as a formula.
    TrimWhitespaceRequest trimWhitespace?;
    # Unmerges cells in the given range.
    UnmergeCellsRequest unmergeCells?;
    # Updates properties of the supplied banded range.
    UpdateBandingRequest updateBanding?;
    # Updates the borders of a range. If a field is not set in the request, that means the border remains as-is. For example, with two subsequent UpdateBordersRequest: 1. range: A1:A5 `{ top: RED, bottom: WHITE }` 2. range: A1:A5 `{ left: BLUE }` That would result in A1:A5 having a borders of `{ top: RED, bottom: WHITE, left: BLUE }`. If you want to clear a border, explicitly set the style to NONE.
    UpdateBordersRequest updateBorders?;
    # Updates all cells in a range with new data.
    UpdateCellsRequest updateCells?;
    # Updates a chart's specifications. (This does not move or resize a chart. To move or resize a chart, use UpdateEmbeddedObjectPositionRequest.)
    UpdateChartSpecRequest updateChartSpec?;
    # Updates a conditional format rule at the given index, or moves a conditional format rule to another index.
    UpdateConditionalFormatRuleRequest updateConditionalFormatRule?;
    # Updates a data source. After the data source is updated successfully, an execution is triggered to refresh the associated DATA_SOURCE sheet to read data from the updated data source. The request requires an additional `bigquery.readonly` OAuth scope.
    UpdateDataSourceRequest updateDataSource?;
    # A request to update properties of developer metadata. Updates the properties of the developer metadata selected by the filters to the values provided in the DeveloperMetadata resource. Callers must specify the properties they wish to update in the fields parameter, as well as specify at least one DataFilter matching the metadata they wish to update.
    UpdateDeveloperMetadataRequest updateDeveloperMetadata?;
    # Updates the state of the specified group.
    UpdateDimensionGroupRequest updateDimensionGroup?;
    # Updates properties of dimensions within the specified range.
    UpdateDimensionPropertiesRequest updateDimensionProperties?;
    # Updates an embedded object's border property.
    UpdateEmbeddedObjectBorderRequest updateEmbeddedObjectBorder?;
    # Update an embedded object's position (such as a moving or resizing a chart or image).
    UpdateEmbeddedObjectPositionRequest updateEmbeddedObjectPosition?;
    # Updates properties of the filter view.
    UpdateFilterViewRequest updateFilterView?;
    # Updates properties of the named range with the specified namedRangeId.
    UpdateNamedRangeRequest updateNamedRange?;
    # Updates an existing protected range with the specified protectedRangeId.
    UpdateProtectedRangeRequest updateProtectedRange?;
    # Updates properties of the sheet with the specified sheetId.
    UpdateSheetPropertiesRequest updateSheetProperties?;
    # Updates a slicer's specifications. (This does not move or resize a slicer. To move or resize a slicer use UpdateEmbeddedObjectPositionRequest.
    UpdateSlicerSpecRequest updateSlicerSpec?;
    # Updates properties of a spreadsheet.
    UpdateSpreadsheetPropertiesRequest updateSpreadsheetProperties?;
};

# The result of updating a conditional format rule.
public type UpdateConditionalFormatRuleResponse record {
    # The index of the new rule.
    int:Signed32 newIndex?;
    # A rule describing a conditional format.
    ConditionalFormatRule newRule?;
    # The old index of the rule. Not set if a rule was replaced (because it is the same as new_index).
    int:Signed32 oldIndex?;
    # A rule describing a conditional format.
    ConditionalFormatRule oldRule?;
};

# The result of the find/replace.
public type FindReplaceResponse record {
    # The number of formula cells changed.
    int:Signed32 formulasChanged?;
    # The number of occurrences (possibly multiple within a cell) changed. For example, if replacing `"e"` with `"o"` in `"Google Sheets"`, this would be `"3"` because `"Google Sheets"` -> `"Googlo Shoots"`.
    int:Signed32 occurrencesChanged?;
    # The number of rows changed.
    int:Signed32 rowsChanged?;
    # The number of sheets changed.
    int:Signed32 sheetsChanged?;
    # The number of non-formula cells changed.
    int:Signed32 valuesChanged?;
};

# A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
public type DimensionRange record {
    # The dimension of the span.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" dimension?;
    # The end (exclusive) of the span, or not set if unbounded.
    int:Signed32 endIndex?;
    # The sheet this span is on.
    int:Signed32 sheetId?;
    # The start (inclusive) of the span, or not set if unbounded.
    int:Signed32 startIndex?;
};

# A scorecard chart. Scorecard charts are used to highlight key performance indicators, known as KPIs, on the spreadsheet. A scorecard chart can represent things like total sales, average cost, or a top selling item. You can specify a single data value, or aggregate over a range of data. Percentage or absolute difference from a baseline value can be highlighted, like changes over time.
public type ScorecardChartSpec record {
    # The aggregation type for key and baseline chart data in scorecard chart. This field is not supported for data source charts. Use the ChartData.aggregateType field of the key_value_data or baseline_value_data instead for data source charts. This field is optional.
    "CHART_AGGREGATE_TYPE_UNSPECIFIED"|"AVERAGE"|"COUNT"|"MAX"|"MEDIAN"|"MIN"|"SUM" aggregateType?;
    # The data included in a domain or series.
    ChartData baselineValueData?;
    # Formatting options for baseline value.
    BaselineValueFormat baselineValueFormat?;
    # Custom number formatting options for chart attributes.
    ChartCustomNumberFormatOptions customFormatOptions?;
    # The data included in a domain or series.
    ChartData keyValueData?;
    # Formatting options for key value.
    KeyValueFormat keyValueFormat?;
    # The number format source used in the scorecard chart. This field is optional.
    "CHART_NUMBER_FORMAT_SOURCE_UNDEFINED"|"FROM_DATA"|"CUSTOM" numberFormatSource?;
    # Value to scale scorecard key and baseline value. For example, a factor of 10 can be used to divide all values in the chart by 10. This field is optional.
    decimal scaleFactor?;
};

# Updates properties of the sheet with the specified sheetId.
public type UpdateSheetPropertiesRequest record {
    # The fields that should be updated. At least one field must be specified. The root `properties` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # Properties of a sheet.
    SheetProperties properties?;
};

# A data source table, which allows the user to import a static table of data from the DataSource into Sheets. This is also known as "Extract" in the Sheets editor.
public type DataSourceTable record {
    # The type to select columns for the data source table. Defaults to SELECTED.
    "DATA_SOURCE_TABLE_COLUMN_SELECTION_TYPE_UNSPECIFIED"|"SELECTED"|"SYNC_ALL" columnSelectionType?;
    # Columns selected for the data source table. The column_selection_type must be SELECTED.
    DataSourceColumnReference[] columns?;
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # The ID of the data source the data source table is associated with.
    string dataSourceId?;
    # Filter specifications in the data source table.
    FilterSpec[] filterSpecs?;
    # The limit of rows to return. If not set, a default limit is applied. Please refer to the Sheets editor for the default and max limit.
    int:Signed32 rowLimit?;
    # Sort specifications in the data source table. The result of the data source table is sorted based on the sort specifications in order.
    SortSpec[] sortSpecs?;
};

# The count limit on rows or columns in the pivot group.
public type PivotGroupLimit record {
    # The order in which the group limit is applied to the pivot table. Pivot group limits are applied from lower to higher order number. Order numbers are normalized to consecutive integers from 0. For write request, to fully customize the applying orders, all pivot group limits should have this field set with an unique number. Otherwise, the order is determined by the index in the PivotTable.rows list and then the PivotTable.columns list.
    int:Signed32 applyOrder?;
    # The count limit.
    int:Signed32 countLimit?;
};

# The position of an embedded object such as a chart.
public type EmbeddedObjectPosition record {
    # If true, the embedded object is put on a new sheet whose ID is chosen for you. Used only when writing.
    boolean newSheet?;
    # The location an object is overlaid on top of a grid.
    OverlayPosition overlayPosition?;
    # The sheet this is on. Set only if the embedded object is on its own sheet. Must be non-negative.
    int:Signed32 sheetId?;
};

# Data in the grid, as well as metadata about the dimensions.
public type GridData record {
    # Metadata about the requested columns in the grid, starting with the column in start_column.
    DimensionProperties[] columnMetadata?;
    # The data in the grid, one entry per row, starting with the row in startRow. The values in RowData will correspond to columns starting at start_column.
    RowData[] rowData?;
    # Metadata about the requested rows in the grid, starting with the row in start_row.
    DimensionProperties[] rowMetadata?;
    # The first column this GridData refers to, zero-based.
    int:Signed32 startColumn?;
    # The first row this GridData refers to, zero-based.
    int:Signed32 startRow?;
};

# A named range.
public type NamedRange record {
    # The name of the named range.
    string name?;
    # The ID of the named range.
    string namedRangeId?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# The result of updating an embedded object's position.
public type UpdateEmbeddedObjectPositionResponse record {
    # The position of an embedded object such as a chart.
    EmbeddedObjectPosition position?;
};

# Finds and replaces data in cells over a range, sheet, or all sheets.
public type FindReplaceRequest record {
    # True to find/replace over all sheets.
    boolean allSheets?;
    # The value to search.
    string find?;
    # True if the search should include cells with formulas. False to skip cells with formulas.
    boolean includeFormulas?;
    # True if the search is case sensitive.
    boolean matchCase?;
    # True if the find value should match the entire cell.
    boolean matchEntireCell?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The value to use as the replacement.
    string replacement?;
    # True if the find value is a regex. The regular expression and replacement should follow Java regex rules at https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html. The replacement string is allowed to refer to capturing groups. For example, if one cell has the contents `"Google Sheets"` and another has `"Google Docs"`, then searching for `"o.* (.*)"` with a replacement of `"$1 Rocks"` would change the contents of the cells to `"GSheets Rocks"` and `"GDocs Rocks"` respectively.
    boolean searchByRegex?;
    # The sheet to find/replace over.
    int:Signed32 sheetId?;
};

# The number format of a cell.
public type NumberFormat record {
    # Pattern string used for formatting. If not set, a default pattern based on the user's locale will be used if necessary for the given type. See the [Date and Number Formats guide](/sheets/api/guides/formats) for more information about the supported patterns.
    string pattern?;
    # The type of the number format. When writing, this field must be set.
    "NUMBER_FORMAT_TYPE_UNSPECIFIED"|"TEXT"|"NUMBER"|"PERCENT"|"CURRENCY"|"DATE"|"TIME"|"DATE_TIME"|"SCIENTIFIC" 'type?;
};

# Additional properties of a DATA_SOURCE sheet.
public type DataSourceSheetProperties record {
    # The columns displayed on the sheet, corresponding to the values in RowData.
    DataSourceColumn[] columns?;
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # ID of the DataSource the sheet is connected to.
    string dataSourceId?;
};

# A range along a single dimension on a DATA_SOURCE sheet.
public type DataSourceSheetDimensionRange record {
    # The columns on the data source sheet.
    DataSourceColumnReference[] columnReferences?;
    # The ID of the data source sheet the range is on.
    int:Signed32 sheetId?;
};

# Information about which values in a pivot group should be used for sorting.
public type PivotGroupSortValueBucket record {
    # Determines the bucket from which values are chosen to sort. For example, in a pivot table with one row group & two column groups, the row group can list up to two values. The first value corresponds to a value within the first column group, and the second value corresponds to a value in the second column group. If no values are listed, this would indicate that the row should be sorted according to the "Grand Total" over the column groups. If a single value is listed, this would correspond to using the "Total" of that bucket.
    ExtendedValue[] buckets?;
    # The offset in the PivotTable.values list which the values in this grouping should be sorted by.
    int:Signed32 valuesIndex?;
};

# The Candlestick chart data, each containing the low, open, close, and high values for a series.
public type CandlestickData record {
    # The series of a CandlestickData.
    CandlestickSeries closeSeries?;
    # The series of a CandlestickData.
    CandlestickSeries highSeries?;
    # The series of a CandlestickData.
    CandlestickSeries lowSeries?;
    # The series of a CandlestickData.
    CandlestickSeries openSeries?;
};

# Moves data from the source to the destination.
public type CutPasteRequest record {
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate destination?;
    # What kind of data to paste. All the source data will be cut, regardless of what is pasted.
    "PASTE_NORMAL"|"PASTE_VALUES"|"PASTE_FORMAT"|"PASTE_NO_BORDERS"|"PASTE_FORMULA"|"PASTE_DATA_VALIDATION"|"PASTE_CONDITIONAL_FORMATTING" pasteType?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange 'source?;
};

# Metadata about a value in a pivot grouping.
public type PivotGroupValueMetadata record {
    # True if the data corresponding to the value is collapsed.
    boolean collapsed?;
    # The kinds of value that a cell in a spreadsheet can have.
    ExtendedValue value?;
};

# The definition of how a value in a pivot table should be calculated.
public type PivotValue record {
    # If specified, indicates that pivot values should be displayed as the result of a calculation with another pivot value. For example, if calculated_display_type is specified as PERCENT_OF_GRAND_TOTAL, all the pivot values are displayed as the percentage of the grand total. In the Sheets editor, this is referred to as "Show As" in the value section of a pivot table.
    "PIVOT_VALUE_CALCULATED_DISPLAY_TYPE_UNSPECIFIED"|"PERCENT_OF_ROW_TOTAL"|"PERCENT_OF_COLUMN_TOTAL"|"PERCENT_OF_GRAND_TOTAL" calculatedDisplayType?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # A custom formula to calculate the value. The formula must start with an `=` character.
    string formula?;
    # A name to use for the value.
    string name?;
    # The column offset of the source range that this value reads from. For example, if the source was `C10:E15`, a `sourceColumnOffset` of `0` means this value refers to column `C`, whereas the offset `1` would refer to column `D`.
    int:Signed32 sourceColumnOffset?;
    # A function to summarize the value. If formula is set, the only supported values are SUM and CUSTOM. If sourceColumnOffset is set, then `CUSTOM` is not supported.
    "PIVOT_STANDARD_VALUE_FUNCTION_UNSPECIFIED"|"SUM"|"COUNTA"|"COUNT"|"COUNTUNIQUE"|"AVERAGE"|"MAX"|"MIN"|"MEDIAN"|"PRODUCT"|"STDEV"|"STDEVP"|"VAR"|"VARP"|"CUSTOM" summarizeFunction?;
};

# The domain of a waterfall chart.
public type WaterfallChartDomain record {
    # The data included in a domain or series.
    ChartData data?;
    # True to reverse the order of the domain values (horizontal axis).
    boolean reversed?;
};

# A reply to a developer metadata search request.
public type SearchDeveloperMetadataResponse record {
    # The metadata matching the criteria of the search request.
    MatchedDeveloperMetadata[] matchedDeveloperMetadata?;
};

# The format of a run of text in a cell. Absent values indicate that the field isn't specified.
public type TextFormat record {
    # True if the text is bold.
    boolean bold?;
    # The font family.
    string fontFamily?;
    # The size of the font.
    int:Signed32 fontSize?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color foregroundColor?;
    # A color value.
    ColorStyle foregroundColorStyle?;
    # True if the text is italicized.
    boolean italic?;
    # An external or local reference.
    Link link?;
    # True if the text has a strikethrough.
    boolean strikethrough?;
    # True if the text is underlined.
    boolean underline?;
};

# The result of deleting a group.
public type DeleteDimensionGroupResponse record {
    # All groups of a dimension after deleting a group from that dimension.
    DimensionGroup[] dimensionGroups?;
};

# Updates the state of the specified group.
public type UpdateDimensionGroupRequest record {
    # A group over an interval of rows or columns on a sheet, which can contain or be contained within other groups. A group can be collapsed or expanded as a unit on the sheet.
    DimensionGroup dimensionGroup?;
    # The fields that should be updated. At least one field must be specified. The root `dimensionGroup` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
};

# Adds a named range to the spreadsheet.
public type AddNamedRangeRequest record {
    # A named range.
    NamedRange namedRange?;
};

# Adds new cells after the last row with data in a sheet, inserting new rows into the sheet if necessary.
public type AppendCellsRequest record {
    # The fields of CellData that should be updated. At least one field must be specified. The root is the CellData; 'row.values.' should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # The data to append.
    RowData[] rows?;
    # The sheet ID to append the data to.
    int:Signed32 sheetId?;
};

# Properties of a spreadsheet.
public type SpreadsheetProperties record {
    # The amount of time to wait before volatile functions are recalculated.
    "RECALCULATION_INTERVAL_UNSPECIFIED"|"ON_CHANGE"|"MINUTE"|"HOUR" autoRecalc?;
    # The format of a cell.
    CellFormat defaultFormat?;
    # Settings to control how circular dependencies are resolved with iterative calculation.
    IterativeCalculationSettings iterativeCalculationSettings?;
    # The locale of the spreadsheet in one of the following formats: * an ISO 639-1 language code such as `en` * an ISO 639-2 language code such as `fil`, if no 639-1 code exists * a combination of the ISO language code and country code, such as `en_US` Note: when updating this field, not all locales/languages are supported.
    string locale?;
    # Represents spreadsheet theme
    SpreadsheetTheme spreadsheetTheme?;
    # The time zone of the spreadsheet, in CLDR format such as `America/New_York`. If the time zone isn't recognized, this may be a custom time zone such as `GMT-07:00`.
    string timeZone?;
    # The title of the spreadsheet.
    string title?;
};

# The result of adding a named range.
public type AddNamedRangeResponse record {
    # A named range.
    NamedRange namedRange?;
};

# The data included in a domain or series.
public type ChartData record {
    # The aggregation type for the series of a data source chart. Only supported for data source charts.
    "CHART_AGGREGATE_TYPE_UNSPECIFIED"|"AVERAGE"|"COUNT"|"MAX"|"MEDIAN"|"MIN"|"SUM" aggregateType?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference columnReference?;
    # An optional setting on the ChartData of the domain of a data source chart that defines buckets for the values in the domain rather than breaking out each individual value. For example, when plotting a data source chart, you can specify a histogram rule on the domain (it should only contain numeric values), grouping its values into buckets. Any values of a chart series that fall into the same bucket are aggregated based on the aggregate_type.
    ChartGroupRule groupRule?;
    # Source ranges for a chart.
    ChartSourceRange sourceRange?;
};

# A histogram series containing the series color and data.
public type HistogramSeries record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color barColor?;
    # A color value.
    ColorStyle barColorStyle?;
    # The data included in a domain or series.
    ChartData data?;
};

# Formatting options for baseline value.
public type BaselineValueFormat record {
    # The comparison type of key value with baseline value.
    "COMPARISON_TYPE_UNDEFINED"|"ABSOLUTE_DIFFERENCE"|"PERCENTAGE_DIFFERENCE" comparisonType?;
    # Description which is appended after the baseline value. This field is optional.
    string description?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color negativeColor?;
    # A color value.
    ColorStyle negativeColorStyle?;
    # Position settings for text.
    TextPosition position?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color positiveColor?;
    # A color value.
    ColorStyle positiveColorStyle?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
};

# A color value.
public type ColorStyle record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color rgbColor?;
    # Theme color.
    "THEME_COLOR_TYPE_UNSPECIFIED"|"TEXT"|"BACKGROUND"|"ACCENT1"|"ACCENT2"|"ACCENT3"|"ACCENT4"|"ACCENT5"|"ACCENT6"|"LINK" themeColor?;
};

# The specifications of a chart.
public type ChartSpec record {
    # The alternative text that describes the chart. This is often used for accessibility.
    string altText?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color backgroundColor?;
    # A color value.
    ColorStyle backgroundColorStyle?;
    # The specification for a basic chart. See BasicChartType for the list of charts this supports.
    BasicChartSpec basicChart?;
    # A bubble chart.
    BubbleChartSpec bubbleChart?;
    # A candlestick chart.
    CandlestickChartSpec candlestickChart?;
    # Properties of a data source chart.
    DataSourceChartProperties dataSourceChartProperties?;
    # The filters applied to the source data of the chart. Only supported for data source charts.
    FilterSpec[] filterSpecs?;
    # The name of the font to use by default for all chart text (e.g. title, axis labels, legend). If a font is specified for a specific part of the chart it will override this font name.
    string fontName?;
    # Determines how the charts will use hidden rows or columns.
    "CHART_HIDDEN_DIMENSION_STRATEGY_UNSPECIFIED"|"SKIP_HIDDEN_ROWS_AND_COLUMNS"|"SKIP_HIDDEN_ROWS"|"SKIP_HIDDEN_COLUMNS"|"SHOW_ALL" hiddenDimensionStrategy?;
    # A histogram chart. A histogram chart groups data items into bins, displaying each bin as a column of stacked items. Histograms are used to display the distribution of a dataset. Each column of items represents a range into which those items fall. The number of bins can be chosen automatically or specified explicitly.
    HistogramChartSpec histogramChart?;
    # True to make a chart fill the entire space in which it's rendered with minimum padding. False to use the default padding. (Not applicable to Geo and Org charts.)
    boolean maximized?;
    # An org chart. Org charts require a unique set of labels in labels and may optionally include parent_labels and tooltips. parent_labels contain, for each node, the label identifying the parent node. tooltips contain, for each node, an optional tooltip. For example, to describe an OrgChart with Alice as the CEO, Bob as the President (reporting to Alice) and Cathy as VP of Sales (also reporting to Alice), have labels contain "Alice", "Bob", "Cathy", parent_labels contain "", "Alice", "Alice" and tooltips contain "CEO", "President", "VP Sales".
    OrgChartSpec orgChart?;
    # A pie chart.
    PieChartSpec pieChart?;
    # A scorecard chart. Scorecard charts are used to highlight key performance indicators, known as KPIs, on the spreadsheet. A scorecard chart can represent things like total sales, average cost, or a top selling item. You can specify a single data value, or aggregate over a range of data. Percentage or absolute difference from a baseline value can be highlighted, like changes over time.
    ScorecardChartSpec scorecardChart?;
    # The order to sort the chart data by. Only a single sort spec is supported. Only supported for data source charts.
    SortSpec[] sortSpecs?;
    # The subtitle of the chart.
    string subtitle?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat subtitleTextFormat?;
    # Position settings for text.
    TextPosition subtitleTextPosition?;
    # The title of the chart.
    string title?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat titleTextFormat?;
    # Position settings for text.
    TextPosition titleTextPosition?;
    # A Treemap chart.
    TreemapChartSpec treemapChart?;
    # A waterfall chart.
    WaterfallChartSpec waterfallChart?;
};

# A rule that may or may not match, depending on the condition.
public type BooleanRule record {
    # A condition that can evaluate to true or false. BooleanConditions are used by conditional formatting, data validation, and the criteria in filters.
    BooleanCondition condition?;
    # The format of a cell.
    CellFormat format?;
};

# The result of adding a slicer to a spreadsheet.
public type AddSlicerResponse record {
    # A slicer in a sheet.
    Slicer slicer?;
};

# The response from updating developer metadata.
public type UpdateDeveloperMetadataResponse record {
    # The updated developer metadata.
    DeveloperMetadata[] developerMetadata?;
};

# The domain of a chart. For example, if charting stock prices over time, this would be the date.
public type BasicChartDomain record {
    # The data included in a domain or series.
    ChartData domain?;
    # True to reverse the order of the domain values (horizontal axis).
    boolean reversed?;
};

# The request for retrieving a range of values in a spreadsheet selected by a set of DataFilters.
public type BatchGetValuesByDataFilterRequest record {
    # The data filters used to match the ranges of values to retrieve. Ranges that match any of the specified data filters are included in the response.
    DataFilter[] dataFilters?;
    # How dates, times, and durations should be represented in the output. This is ignored if value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    "SERIAL_NUMBER"|"FORMATTED_STRING" dateTimeRenderOption?;
    # The major dimension that results should use. For example, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`, then a request that selects that range and sets `majorDimension=ROWS` returns `[[1,2],[3,4]]`, whereas a request that sets `majorDimension=COLUMNS` returns `[[1,3],[2,4]]`.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" majorDimension?;
    # How values should be represented in the output. The default render option is FORMATTED_VALUE.
    "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA" valueRenderOption?;
};

# An optional setting on the ChartData of the domain of a data source chart that defines buckets for the values in the domain rather than breaking out each individual value. For example, when plotting a data source chart, you can specify a histogram rule on the domain (it should only contain numeric values), grouping its values into buckets. Any values of a chart series that fall into the same bucket are aggregated based on the aggregate_type.
public type ChartGroupRule record {
    # Allows you to organize the date-time values in a source data column into buckets based on selected parts of their date or time values.
    ChartDateTimeRule dateTimeRule?;
    # Allows you to organize numeric values in a source data column into buckets of constant size.
    ChartHistogramRule histogramRule?;
};

# Represents a time interval, encoded as a Timestamp start (inclusive) and a Timestamp end (exclusive). The start must be less than or equal to the end. When the start equals the end, the interval is empty (matches no time). When both start and end are unspecified, the interval matches any time.
public type Interval record {
    # Optional. Exclusive end of the interval. If specified, a Timestamp matching this interval will have to be before the end.
    string endTime?;
    # Optional. Inclusive start of the interval. If specified, a Timestamp matching this interval will have to be the same or after the start.
    string startTime?;
};

# A single interpolation point on a gradient conditional format. These pin the gradient color scale according to the color, type and value chosen.
public type InterpolationPoint record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
    # How the value should be interpreted.
    "INTERPOLATION_POINT_TYPE_UNSPECIFIED"|"MIN"|"MAX"|"NUMBER"|"PERCENT"|"PERCENTILE" 'type?;
    # The value this interpolation point uses. May be a formula. Unused if type is MIN or MAX.
    string value?;
};

# The value of the condition.
public type ConditionValue record {
    # A relative date (based on the current date). Valid only if the type is DATE_BEFORE, DATE_AFTER, DATE_ON_OR_BEFORE or DATE_ON_OR_AFTER. Relative dates are not supported in data validation. They are supported only in conditional formatting and conditional filters.
    "RELATIVE_DATE_UNSPECIFIED"|"PAST_YEAR"|"PAST_MONTH"|"PAST_WEEK"|"YESTERDAY"|"TODAY"|"TOMORROW" relativeDate?;
    # A value the condition is based on. The value is parsed as if the user typed into a cell. Formulas are supported (and must begin with an `=` or a '+').
    string userEnteredValue?;
};

# The filter criteria associated with a specific column.
public type FilterSpec record {
    # The column index.
    int:Signed32 columnIndex?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # Criteria for showing/hiding rows in a filter or filter view.
    FilterCriteria filterCriteria?;
};

# The reply for batch updating a spreadsheet.
public type BatchUpdateSpreadsheetResponse record {
    # The reply of the updates. This maps 1:1 with the updates, although replies to some requests may be empty.
    Response[] replies?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
    # Resource that represents a spreadsheet.
    Spreadsheet updatedSpreadsheet?;
};

# An axis of the chart. A chart may not have more than one axis per axis position.
public type BasicChartAxis record {
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat format?;
    # The position of this axis.
    "BASIC_CHART_AXIS_POSITION_UNSPECIFIED"|"BOTTOM_AXIS"|"LEFT_AXIS"|"RIGHT_AXIS" position?;
    # The title of this axis. If set, this overrides any title inferred from headers of the data.
    string title?;
    # Position settings for text.
    TextPosition titleTextPosition?;
    # The options that define a "view window" for a chart (such as the visible values in an axis).
    ChartAxisViewWindowOptions viewWindowOptions?;
};

# A pie chart.
public type PieChartSpec record {
    # The data included in a domain or series.
    ChartData domain?;
    # Where the legend of the pie chart should be drawn.
    "PIE_CHART_LEGEND_POSITION_UNSPECIFIED"|"BOTTOM_LEGEND"|"LEFT_LEGEND"|"RIGHT_LEGEND"|"TOP_LEGEND"|"NO_LEGEND"|"LABELED_LEGEND" legendPosition?;
    # The size of the hole in the pie chart.
    decimal pieHole?;
    # The data included in a domain or series.
    ChartData series?;
    # True if the pie is three dimensional.
    boolean threeDimensional?;
};

# A bubble chart.
public type BubbleChartSpec record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color bubbleBorderColor?;
    # A color value.
    ColorStyle bubbleBorderColorStyle?;
    # The data included in a domain or series.
    ChartData bubbleLabels?;
    # The max radius size of the bubbles, in pixels. If specified, the field must be a positive value.
    int:Signed32 bubbleMaxRadiusSize?;
    # The minimum radius size of the bubbles, in pixels. If specific, the field must be a positive value.
    int:Signed32 bubbleMinRadiusSize?;
    # The opacity of the bubbles between 0 and 1.0. 0 is fully transparent and 1 is fully opaque.
    float bubbleOpacity?;
    # The data included in a domain or series.
    ChartData bubbleSizes?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat bubbleTextStyle?;
    # The data included in a domain or series.
    ChartData domain?;
    # The data included in a domain or series.
    ChartData groupIds?;
    # Where the legend of the chart should be drawn.
    "BUBBLE_CHART_LEGEND_POSITION_UNSPECIFIED"|"BOTTOM_LEGEND"|"LEFT_LEGEND"|"RIGHT_LEGEND"|"TOP_LEGEND"|"NO_LEGEND"|"INSIDE_LEGEND" legendPosition?;
    # The data included in a domain or series.
    ChartData series?;
};

# Data about each cell in a row.
public type RowData record {
    # The values in the row, one per column.
    CellData[] values?;
};

# Resource that represents a spreadsheet.
public type Spreadsheet record {
    # Output only. A list of data source refresh schedules.
    DataSourceRefreshSchedule[] dataSourceSchedules?;
    # A list of external data sources connected with the spreadsheet.
    DataSource[] dataSources?;
    # The developer metadata associated with a spreadsheet.
    DeveloperMetadata[] developerMetadata?;
    # The named ranges defined in a spreadsheet.
    NamedRange[] namedRanges?;
    # Properties of a spreadsheet.
    SpreadsheetProperties properties?;
    # The sheets that are part of a spreadsheet.
    Sheet[] sheets?;
    # The ID of the spreadsheet. This field is read-only.
    string spreadsheetId?;
    # The url of the spreadsheet. This field is read-only.
    string spreadsheetUrl?;
};

# Deletes a group over the specified range by decrementing the depth of the dimensions in the range. For example, assume the sheet has a depth-1 group over B:E and a depth-2 group over C:D. Deleting a group over D:E leaves the sheet with a depth-1 group over B:D and a depth-2 group over C:C.
public type DeleteDimensionGroupRequest record {
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# The response from refreshing one or multiple data source objects.
public type RefreshDataSourceResponse record {
    # All the refresh status for the data source object references specified in the request. If is_all is specified, the field contains only those in failure status.
    RefreshDataSourceObjectExecutionStatus[] statuses?;
};

# A value range that was matched by one or more data filers.
public type MatchedValueRange record {
    # The DataFilters from the request that matched the range of values.
    DataFilter[] dataFilters?;
    # Data within a range of the spreadsheet.
    GsheetValueRange valueRange?;
};

# Adds a new conditional format rule at the given index. All subsequent rules' indexes are incremented.
public type AddConditionalFormatRuleRequest record {
    # The zero-based index where the rule should be inserted.
    int:Signed32 index?;
    # A rule describing a conditional format.
    ConditionalFormatRule rule?;
};

# Sets the basic filter associated with a sheet.
public type SetBasicFilterRequest record {
    # The default filter associated with a sheet.
    BasicFilter filter?;
};

# Updates properties of a spreadsheet.
public type UpdateSpreadsheetPropertiesRequest record {
    # The fields that should be updated. At least one field must be specified. The root 'properties' is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # Properties of a spreadsheet.
    SpreadsheetProperties properties?;
};

# The request for updating more than one range of values in a spreadsheet.
public type BatchUpdateValuesByDataFilterRequest record {
    # The new values to apply to the spreadsheet. If more than one range is matched by the specified DataFilter the specified values are applied to all of those ranges.
    DataFilterValueRange[] data?;
    # Determines if the update response should include the values of the cells that were updated. By default, responses do not include the updated values. The `updatedData` field within each of the BatchUpdateValuesResponse.responses contains the updated values. If the range to write was larger than the range actually written, the response includes all values in the requested range (excluding trailing empty rows and columns).
    boolean includeValuesInResponse?;
    # Determines how dates, times, and durations in the response should be rendered. This is ignored if response_value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    "SERIAL_NUMBER"|"FORMATTED_STRING" responseDateTimeRenderOption?;
    # Determines how values in the response should be rendered. The default render option is FORMATTED_VALUE.
    "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA" responseValueRenderOption?;
    # How the input data should be interpreted.
    // NOTE: valueInputOption is required
    "INPUT_VALUE_OPTION_UNSPECIFIED"|"RAW"|"USER_ENTERED" valueInputOption?;
};

# Removes rows within this range that contain values in the specified columns that are duplicates of values in any previous row. Rows with identical values but different letter cases, formatting, or formulas are considered to be duplicates. This request also removes duplicate rows hidden from view (for example, due to a filter). When removing duplicates, the first instance of each duplicate row scanning from the top downwards is kept in the resulting range. Content outside of the specified range isn't removed, and rows considered duplicates do not have to be adjacent to each other in the range.
public type DeleteDuplicatesRequest record {
    # The columns in the range to analyze for duplicate values. If no columns are selected then all columns are analyzed for duplicates.
    DimensionRange[] comparisonColumns?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# Refreshes one or multiple data source objects in the spreadsheet by the specified references. The request requires an additional `bigquery.readonly` OAuth scope. If there are multiple refresh requests referencing the same data source objects in one batch, only the last refresh request is processed, and all those requests will have the same response accordingly.
public type RefreshDataSourceRequest record {
    # Reference to a DataSource. If specified, refreshes all associated data source objects for the data source.
    string dataSourceId?;
    # Refreshes the data source objects regardless of the current state. If not set and a referenced data source object was in error state, the refresh will fail immediately.
    boolean force?;
    # Refreshes all existing data source objects in the spreadsheet.
    boolean isAll?;
    # A list of references to data source objects.
    DataSourceObjectReferences references?;
};

# The kinds of value that a cell in a spreadsheet can have.
public type ExtendedValue record {
    # Represents a boolean value.
    boolean boolValue?;
    # An error in a cell.
    ErrorValue errorValue?;
    # Represents a formula.
    string formulaValue?;
    # Represents a double value. Note: Dates, Times and DateTimes are represented as doubles in SERIAL_NUMBER format.
    decimal numberValue?;
    # Represents a string value. Leading single quotes are not included. For example, if the user typed `'123` into the UI, this would be represented as a `stringValue` of `"123"`.
    string stringValue?;
};

# A developer metadata entry and the data filters specified in the original request that matched it.
public type MatchedDeveloperMetadata record {
    # All filters matching the returned developer metadata.
    DataFilter[] dataFilters?;
    # Developer metadata associated with a location or object in a spreadsheet. Developer metadata may be used to associate arbitrary data with various parts of a spreadsheet and will remain associated at those locations as they move around and the spreadsheet is edited. For example, if developer metadata is associated with row 5 and another row is then subsequently inserted above row 5, that original metadata will still be associated with the row it was first associated with (what is now row 6). If the associated object is deleted its metadata is deleted too.
    DeveloperMetadata developerMetadata?;
};

# The request to copy a sheet across spreadsheets.
public type CopySheetToAnotherSpreadsheetRequest record {
    # The ID of the spreadsheet to copy the sheet to.
    string destinationSpreadsheetId?;
};

# The response from deleting developer metadata.
public type DeleteDeveloperMetadataResponse record {
    # The metadata that was deleted.
    DeveloperMetadata[] deletedDeveloperMetadata?;
};

# Data about a specific cell.
public type CellData record {
    # A data source formula.
    DataSourceFormula dataSourceFormula?;
    # A data source table, which allows the user to import a static table of data from the DataSource into Sheets. This is also known as "Extract" in the Sheets editor.
    DataSourceTable dataSourceTable?;
    # A data validation rule.
    DataValidationRule dataValidation?;
    # The format of a cell.
    CellFormat effectiveFormat?;
    # The kinds of value that a cell in a spreadsheet can have.
    ExtendedValue effectiveValue?;
    # The formatted value of the cell. This is the value as it's shown to the user. This field is read-only.
    string formattedValue?;
    # A hyperlink this cell points to, if any. If the cell contains multiple hyperlinks, this field will be empty. This field is read-only. To set it, use a `=HYPERLINK` formula in the userEnteredValue.formulaValue field. A cell-level link can also be set from the userEnteredFormat.textFormat field. Alternatively, set a hyperlink in the textFormatRun.format.link field that spans the entire cell.
    string hyperlink?;
    # Any note on the cell.
    string note?;
    # A pivot table.
    PivotTable pivotTable?;
    # Runs of rich text applied to subsections of the cell. Runs are only valid on user entered strings, not formulas, bools, or numbers. Properties of a run start at a specific index in the text and continue until the next run. Runs will inherit the properties of the cell unless explicitly changed. When writing, the new runs will overwrite any prior runs. When writing a new user_entered_value, previous runs are erased.
    TextFormatRun[] textFormatRuns?;
    # The format of a cell.
    CellFormat userEnteredFormat?;
    # The kinds of value that a cell in a spreadsheet can have.
    ExtendedValue userEnteredValue?;
};

# Randomizes the order of the rows in a range.
public type RandomizeRangeRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# The result of adding a sheet.
public type AddSheetResponse record {
    # Properties of a sheet.
    SheetProperties properties?;
};

# Allows you to organize the date-time values in a source data column into buckets based on selected parts of their date or time values. For example, consider a pivot table showing sales transactions by date: +----------+--------------+ | Date | SUM of Sales | +----------+--------------+ | 1/1/2017 | $621.14 | | 2/3/2017 | $708.84 | | 5/8/2017 | $326.84 | ... +----------+--------------+ Applying a date-time group rule with a DateTimeRuleType of YEAR_MONTH results in the following pivot table. +--------------+--------------+ | Grouped Date | SUM of Sales | +--------------+--------------+ | 2017-Jan | $53,731.78 | | 2017-Feb | $83,475.32 | | 2017-Mar | $94,385.05 | ... +--------------+--------------+
public type DateTimeRule record {
    # The type of date-time grouping to apply.
    "DATE_TIME_RULE_TYPE_UNSPECIFIED"|"SECOND"|"MINUTE"|"HOUR"|"HOUR_MINUTE"|"HOUR_MINUTE_AMPM"|"DAY_OF_WEEK"|"DAY_OF_YEAR"|"DAY_OF_MONTH"|"DAY_MONTH"|"MONTH"|"QUARTER"|"YEAR"|"YEAR_MONTH"|"YEAR_QUARTER"|"YEAR_MONTH_DAY" 'type?;
};

# A request to update properties of developer metadata. Updates the properties of the developer metadata selected by the filters to the values provided in the DeveloperMetadata resource. Callers must specify the properties they wish to update in the fields parameter, as well as specify at least one DataFilter matching the metadata they wish to update.
public type UpdateDeveloperMetadataRequest record {
    # The filters matching the developer metadata entries to update.
    DataFilter[] dataFilters?;
    # Developer metadata associated with a location or object in a spreadsheet. Developer metadata may be used to associate arbitrary data with various parts of a spreadsheet and will remain associated at those locations as they move around and the spreadsheet is edited. For example, if developer metadata is associated with row 5 and another row is then subsequently inserted above row 5, that original metadata will still be associated with the row it was first associated with (what is now row 6). If the associated object is deleted its metadata is deleted too.
    DeveloperMetadata developerMetadata?;
    # The fields that should be updated. At least one field must be specified. The root `developerMetadata` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
};

# Automatically resizes one or more dimensions based on the contents of the cells in that dimension.
public type AutoResizeDimensionsRequest record {
    # A range along a single dimension on a DATA_SOURCE sheet.
    DataSourceSheetDimensionRange dataSourceSheetDimensions?;
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange dimensions?;
};

# A rule that applies a gradient color scale format, based on the interpolation points listed. The format of a cell will vary based on its contents as compared to the values of the interpolation points.
public type GradientRule record {
    # A single interpolation point on a gradient conditional format. These pin the gradient color scale according to the color, type and value chosen.
    InterpolationPoint maxpoint?;
    # A single interpolation point on a gradient conditional format. These pin the gradient color scale according to the color, type and value chosen.
    InterpolationPoint midpoint?;
    # A single interpolation point on a gradient conditional format. These pin the gradient color scale according to the color, type and value chosen.
    InterpolationPoint minpoint?;
};

# Removes the banded range with the given ID from the spreadsheet.
public type DeleteBandingRequest record {
    # The ID of the banded range to delete.
    int:Signed32 bandedRangeId?;
};

# Adds a slicer to a sheet in the spreadsheet.
public type AddSlicerRequest record {
    # A slicer in a sheet.
    Slicer slicer?;
};

# The result of a filter view being duplicated.
public type DuplicateFilterViewResponse record {
    # A filter view.
    FilterView filter?;
};

# Properties of a data source chart.
public type DataSourceChartProperties record {
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # ID of the data source that the chart is associated with.
    string dataSourceId?;
};

# The style of a point on the chart.
public type PointStyle record {
    # The point shape. If empty or unspecified, a default shape is used.
    "POINT_SHAPE_UNSPECIFIED"|"CIRCLE"|"DIAMOND"|"HEXAGON"|"PENTAGON"|"SQUARE"|"STAR"|"TRIANGLE"|"X_MARK" shape?;
    # The point size. If empty, a default size is used.
    decimal size?;
};

# Schedule for refreshing the data source. Data sources in the spreadsheet are refreshed within a time interval. You can specify the start time by clicking the Scheduled Refresh button in the Sheets editor, but the interval is fixed at 4 hours. For example, if you specify a start time of 8am , the refresh will take place between 8am and 12pm every day.
public type DataSourceRefreshSchedule record {
    # A schedule for data to refresh every day in a given time interval.
    DataSourceRefreshDailySchedule dailySchedule?;
    # True if the refresh schedule is enabled, or false otherwise.
    boolean enabled?;
    # A monthly schedule for data to refresh on specific days in the month in a given time interval.
    DataSourceRefreshMonthlySchedule monthlySchedule?;
    # Represents a time interval, encoded as a Timestamp start (inclusive) and a Timestamp end (exclusive). The start must be less than or equal to the end. When the start equals the end, the interval is empty (matches no time). When both start and end are unspecified, the interval matches any time.
    Interval nextRun?;
    # The scope of the refresh. Must be ALL_DATA_SOURCES.
    "DATA_SOURCE_REFRESH_SCOPE_UNSPECIFIED"|"ALL_DATA_SOURCES" refreshScope?;
    # A weekly schedule for data to refresh on specific days in a given time interval.
    DataSourceRefreshWeeklySchedule weeklySchedule?;
};

# Criteria for showing/hiding rows in a filter or filter view.
public type FilterCriteria record {
    # A condition that can evaluate to true or false. BooleanConditions are used by conditional formatting, data validation, and the criteria in filters.
    BooleanCondition condition?;
    # Values that should be hidden.
    string[] hiddenValues?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color visibleBackgroundColor?;
    # A color value.
    ColorStyle visibleBackgroundColorStyle?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color visibleForegroundColor?;
    # A color value.
    ColorStyle visibleForegroundColorStyle?;
};

# A data validation rule.
public type DataValidationRule record {
    # A condition that can evaluate to true or false. BooleanConditions are used by conditional formatting, data validation, and the criteria in filters.
    BooleanCondition condition?;
    # A message to show the user when adding data to the cell.
    string inputMessage?;
    # True if the UI should be customized based on the kind of condition. If true, "List" conditions will show a dropdown.
    boolean showCustomUi?;
    # True if invalid data should be rejected.
    boolean strict?;
};

# Moves one or more rows or columns.
public type MoveDimensionRequest record {
    # The zero-based start index of where to move the source data to, based on the coordinates *before* the source data is removed from the grid. Existing data will be shifted down or right (depending on the dimension) to make room for the moved dimensions. The source dimensions are removed from the grid, so the the data may end up in a different index than specified. For example, given `A1..A5` of `0, 1, 2, 3, 4` and wanting to move `"1"` and `"2"` to between `"3"` and `"4"`, the source would be `ROWS [1..3)`,and the destination index would be `"4"` (the zero-based index of row 5). The end result would be `A1..A5` of `0, 3, 1, 2, 4`.
    int:Signed32 destinationIndex?;
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange 'source?;
};

# Properties about a dimension.
public type DimensionProperties record {
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # The developer metadata associated with a single row or column.
    DeveloperMetadata[] developerMetadata?;
    # True if this dimension is being filtered. This field is read-only.
    boolean hiddenByFilter?;
    # True if this dimension is explicitly hidden.
    boolean hiddenByUser?;
    # The height (if a row) or width (if a column) of the dimension in pixels.
    int:Signed32 pixelSize?;
};

# A border along an embedded object.
public type EmbeddedObjectBorder record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
};

# The request for retrieving a Spreadsheet.
public type GetSpreadsheetByDataFilterRequest record {
    # The DataFilters used to select which ranges to retrieve from the spreadsheet.
    DataFilter[] dataFilters?;
    # True if grid data should be returned. This parameter is ignored if a field mask was set in the request.
    boolean includeGridData?;
};

# The response when retrieving more than one range of values in a spreadsheet.
public type BatchGetValuesResponse record {
    # The ID of the spreadsheet the data was retrieved from.
    string spreadsheetId?;
    # The requested values. The order of the ValueRanges is the same as the order of the requested ranges.
    GsheetValueRange[] valueRanges?;
};

# Properties of a sheet.
public type SheetProperties record {
    # Additional properties of a DATA_SOURCE sheet.
    DataSourceSheetProperties dataSourceSheetProperties?;
    # Properties of a grid.
    GridProperties gridProperties?;
    # True if the sheet is hidden in the UI, false if it's visible.
    boolean hidden?;
    # The index of the sheet within the spreadsheet. When adding or updating sheet properties, if this field is excluded then the sheet is added or moved to the end of the sheet list. When updating sheet indices or inserting sheets, movement is considered in "before the move" indexes. For example, if there were 3 sheets (S1, S2, S3) in order to move S1 ahead of S2 the index would have to be set to 2. A sheet index update request is ignored if the requested index is identical to the sheets current index or if the requested new index is equal to the current sheet index + 1.
    int:Signed32 index?;
    # True if the sheet is an RTL sheet instead of an LTR sheet.
    boolean rightToLeft?;
    # The ID of the sheet. Must be non-negative. This field cannot be changed once set.
    int:Signed32 sheetId?;
    # The type of sheet. Defaults to GRID. This field cannot be changed once set.
    "SHEET_TYPE_UNSPECIFIED"|"GRID"|"OBJECT"|"DATA_SOURCE" sheetType?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color tabColor?;
    # A color value.
    ColorStyle tabColorStyle?;
    # The name of the sheet.
    string title?;
};

# Style override settings for a single series data point.
public type BasicSeriesDataPointStyleOverride record {
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color color?;
    # A color value.
    ColorStyle colorStyle?;
    # Zero based index of the series data point.
    int:Signed32 index?;
    # The style of a point on the chart.
    PointStyle pointStyle?;
};

# A Treemap chart.
public type TreemapChartSpec record {
    # The data included in a domain or series.
    ChartData colorData?;
    # A color scale for a treemap chart.
    TreemapChartColorScale colorScale?;
    # Represents a color in the RGBA color space. This representation is designed for simplicity of conversion to and from color representations in various languages over compactness. For example, the fields of this representation can be trivially provided to the constructor of `java.awt.Color` in Java; it can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha` method in iOS; and, with just a little work, it can be easily formatted into a CSS `rgba()` string in JavaScript. This reference page doesn't have information about the absolute color space that should be used to interpret the RGB value—for example, sRGB, Adobe RGB, DCI-P3, and BT.2020. By default, applications should assume the sRGB color space. When color equality needs to be decided, implementations, unless documented otherwise, treat two colors as equal if all their red, green, blue, and alpha values each differ by at most `1e-5`. Example (Java): import com.google.type.Color; // ... public static java.awt.Color fromProto(Color protocolor) { float alpha = protocolor.hasAlpha() ? protocolor.getAlpha().getValue() : 1.0; return new java.awt.Color( protocolor.getRed(), protocolor.getGreen(), protocolor.getBlue(), alpha); } public static Color toProto(java.awt.Color color) { float red = (float) color.getRed(); float green = (float) color.getGreen(); float blue = (float) color.getBlue(); float denominator = 255.0; Color.Builder resultBuilder = Color .newBuilder() .setRed(red / denominator) .setGreen(green / denominator) .setBlue(blue / denominator); int alpha = color.getAlpha(); if (alpha != 255) { result.setAlpha( FloatValue .newBuilder() .setValue(((float) alpha) / denominator) .build()); } return resultBuilder.build(); } // ... Example (iOS / Obj-C): // ... static UIColor* fromProto(Color* protocolor) { float red = [protocolor red]; float green = [protocolor green]; float blue = [protocolor blue]; FloatValue* alpha_wrapper = [protocolor alpha]; float alpha = 1.0; if (alpha_wrapper != nil) { alpha = [alpha_wrapper value]; } return [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; } static Color* toProto(UIColor* color) { CGFloat red, green, blue, alpha; if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) { return nil; } Color* result = [[Color alloc] init]; [result setRed:red]; [result setGreen:green]; [result setBlue:blue]; if (alpha <= 0.9999) { [result setAlpha:floatWrapperWithValue(alpha)]; } [result autorelease]; return result; } // ... Example (JavaScript): // ... var protoToCssColor = function(rgb_color) { var redFrac = rgb_color.red || 0.0; var greenFrac = rgb_color.green || 0.0; var blueFrac = rgb_color.blue || 0.0; var red = Math.floor(redFrac * 255); var green = Math.floor(greenFrac * 255); var blue = Math.floor(blueFrac * 255); if (!('alpha' in rgb_color)) { return rgbToCssColor(red, green, blue); } var alphaFrac = rgb_color.alpha.value || 0.0; var rgbParams = [red, green, blue].join(','); return ['rgba(', rgbParams, ',', alphaFrac, ')'].join(''); }; var rgbToCssColor = function(red, green, blue) { var rgbNumber = new Number((red << 16) | (green << 8) | blue); var hexString = rgbNumber.toString(16); var missingZeros = 6 - hexString.length; var resultBuilder = ['#']; for (var i = 0; i < missingZeros; i++) { resultBuilder.push('0'); } resultBuilder.push(hexString); return resultBuilder.join(''); }; // ...
    Color headerColor?;
    # A color value.
    ColorStyle headerColorStyle?;
    # True to hide tooltips.
    boolean hideTooltips?;
    # The number of additional data levels beyond the labeled levels to be shown on the treemap chart. These levels are not interactive and are shown without their labels. Defaults to 0 if not specified.
    int:Signed32 hintedLevels?;
    # The data included in a domain or series.
    ChartData labels?;
    # The number of data levels to show on the treemap chart. These levels are interactive and are shown with their labels. Defaults to 2 if not specified.
    int:Signed32 levels?;
    # The maximum possible data value. Cells with values greater than this will have the same color as cells with this value. If not specified, defaults to the actual maximum value from color_data, or the maximum value from size_data if color_data is not specified.
    decimal maxValue?;
    # The minimum possible data value. Cells with values less than this will have the same color as cells with this value. If not specified, defaults to the actual minimum value from color_data, or the minimum value from size_data if color_data is not specified.
    decimal minValue?;
    # The data included in a domain or series.
    ChartData parentLabels?;
    # The data included in a domain or series.
    ChartData sizeData?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
};

# The response when updating a range of values in a spreadsheet.
public type AppendValuesResponse record {
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
    # The range (in A1 notation) of the table that values are being appended to (before the values were appended). Empty if no table was found.
    string tableRange?;
    # The response when updating a range of values in a spreadsheet.
    UpdateValuesResponse updates?;
};

# A data source formula.
public type DataSourceFormula record {
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # The ID of the data source the formula is associated with.
    string dataSourceId?;
};

# Duplicates the contents of a sheet.
public type DuplicateSheetRequest record {
    # The zero-based index where the new sheet should be inserted. The index of all sheets after this are incremented.
    int:Signed32 insertSheetIndex?;
    # If set, the ID of the new sheet. If not set, an ID is chosen. If set, the ID must not conflict with any existing sheet ID. If set, it must be non-negative.
    int:Signed32 newSheetId?;
    # The name of the new sheet. If empty, a new name is chosen for you.
    string newSheetName?;
    # The sheet to duplicate. If the source sheet is of DATA_SOURCE type, its backing DataSource is also duplicated and associated with the new copy of the sheet. No data execution is triggered, the grid data of this sheet is also copied over but only available after the batch request completes.
    int:Signed32 sourceSheetId?;
};

# Allows you to manually organize the values in a source data column into buckets with names of your choosing. For example, a pivot table that aggregates population by state: +-------+-------------------+ | State | SUM of Population | +-------+-------------------+ | AK | 0.7 | | AL | 4.8 | | AR | 2.9 | ... +-------+-------------------+ could be turned into a pivot table that aggregates population by time zone by providing a list of groups (for example, groupName = 'Central', items = ['AL', 'AR', 'IA', ...]) to a manual group rule. Note that a similar effect could be achieved by adding a time zone column to the source data and adjusting the pivot table. +-----------+-------------------+ | Time Zone | SUM of Population | +-----------+-------------------+ | Central | 106.3 | | Eastern | 151.9 | | Mountain | 17.4 | ... +-----------+-------------------+
public type ManualRule record {
    # The list of group names and the corresponding items from the source data that map to each group name.
    ManualRuleGroup[] groups?;
};

# Deletes a data source. The request also deletes the associated data source sheet, and unlinks all associated data source objects.
public type DeleteDataSourceRequest record {
    # The ID of the data source to delete.
    string dataSourceId?;
};

# Formatting options for key value.
public type KeyValueFormat record {
    # Position settings for text.
    TextPosition position?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
};

# This specifies the details of the data source. For example, for BigQuery, this specifies information about the BigQuery source.
public type DataSourceSpec record {
    # The specification of a BigQuery data source that's connected to a sheet.
    BigQueryDataSourceSpec bigQuery?;
    # The parameters of the data source, used when querying the data source.
    DataSourceParameter[] parameters?;
};

# The location an object is overlaid on top of a grid.
public type OverlayPosition record {
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate anchorCell?;
    # The height of the object, in pixels. Defaults to 371.
    int:Signed32 heightPixels?;
    # The horizontal offset, in pixels, that the object is offset from the anchor cell.
    int:Signed32 offsetXPixels?;
    # The vertical offset, in pixels, that the object is offset from the anchor cell.
    int:Signed32 offsetYPixels?;
    # The width of the object, in pixels. Defaults to 600.
    int:Signed32 widthPixels?;
};

# A pivot table.
public type PivotTable record {
    # Each column grouping in the pivot table.
    PivotGroup[] columns?;
    # An optional mapping of filters per source column offset. The filters are applied before aggregating data into the pivot table. The map's key is the column offset of the source range that you want to filter, and the value is the criteria for that column. For example, if the source was `C10:E15`, a key of `0` will have the filter for column `C`, whereas the key `1` is for column `D`. This field is deprecated in favor of filter_specs.
    record {|PivotFilterCriteria...;|} criteria?;
    # The data execution status. A data execution is created to sync a data source object with the latest data from a DataSource. It is usually scheduled to run at background, you can check its state to tell if an execution completes There are several scenarios where a data execution is triggered to run: * Adding a data source creates an associated data source sheet as well as a data execution to sync the data from the data source to the sheet. * Updating a data source creates a data execution to refresh the associated data source sheet similarly. * You can send refresh request to explicitly refresh one or multiple data source objects.
    DataExecutionStatus dataExecutionStatus?;
    # The ID of the data source the pivot table is reading data from.
    string dataSourceId?;
    # The filters applied to the source columns before aggregating data for the pivot table. Both criteria and filter_specs are populated in responses. If both fields are specified in an update request, this field takes precedence.
    PivotFilterSpec[] filterSpecs?;
    # Each row grouping in the pivot table.
    PivotGroup[] rows?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange 'source?;
    # Whether values should be listed horizontally (as columns) or vertically (as rows).
    "HORIZONTAL"|"VERTICAL" valueLayout?;
    # A list of values to include in the pivot table.
    PivotValue[] values?;
};

# Data within a range of the spreadsheet.
public type GsheetValueRange record {
    # The major dimension of the values. For output, if the spreadsheet data is: `A1=1,B1=2,A2=3,B2=4`, then requesting `range=A1:B2,majorDimension=ROWS` will return `[[1,2],[3,4]]`, whereas requesting `range=A1:B2,majorDimension=COLUMNS` will return `[[1,3],[2,4]]`. For input, with `range=A1:B2,majorDimension=ROWS` then `[[1,2],[3,4]]` will set `A1=1,B1=2,A2=3,B2=4`. With `range=A1:B2,majorDimension=COLUMNS` then `[[1,2],[3,4]]` will set `A1=1,B1=3,A2=2,B2=4`. When writing, if this field is not set, it defaults to ROWS.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" majorDimension?;
    # The range the values cover, in [A1 notation](/sheets/api/guides/concepts#cell). For output, this range indicates the entire requested range, even though the values will exclude trailing rows and columns. When appending values, this field represents the range to search for a table, after which values will be appended.
    string range?;
    # The data that was read or to be written. This is an array of arrays, the outer array representing all the data and each inner array representing a major dimension. Each item in the inner array corresponds with one cell. For output, empty trailing rows and columns will not be included. For input, supported value types are: bool, string, and double. Null values will be skipped. To set a cell to an empty value, set the string value to an empty string.
    anydata[][] values?;
};

# Deletes the protected range with the given ID.
public type DeleteProtectedRangeRequest record {
    # The ID of the protected range to delete.
    int:Signed32 protectedRangeId?;
};

# The result of trimming whitespace in cells.
public type TrimWhitespaceResponse record {
    # The number of cells that were trimmed of whitespace.
    int:Signed32 cellsChangedCount?;
};

# A candlestick chart.
public type CandlestickChartSpec record {
    # The Candlestick chart data. Only one CandlestickData is supported.
    CandlestickData[] data?;
    # The domain of a CandlestickChart.
    CandlestickDomain domain?;
};

# An error in a cell.
public type ErrorValue record {
    # A message with more information about the error (in the spreadsheet's locale).
    string message?;
    # The type of error.
    "ERROR_TYPE_UNSPECIFIED"|"ERROR"|"NULL_VALUE"|"DIVIDE_BY_ZERO"|"VALUE"|"REF"|"NAME"|"NUM"|"N_A"|"LOADING" 'type?;
};

# A schedule for data to refresh every day in a given time interval.
public type DataSourceRefreshDailySchedule record {
    # Represents a time of day. The date and time zone are either not significant or are specified elsewhere. An API may choose to allow leap seconds. Related types are google.type.Date and `google.protobuf.Timestamp`.
    TimeOfDay startTime?;
};

# Fills in more data based on existing data.
public type AutoFillRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # A combination of a source range and how to extend that source.
    SourceAndDestination sourceAndDestination?;
    # True if we should generate data with the "alternate" series. This differs based on the type and amount of source data.
    boolean useAlternateSeries?;
};

# A banded (alternating colors) range in a sheet.
public type BandedRange record {
    # The id of the banded range.
    int:Signed32 bandedRangeId?;
    # Properties referring a single dimension (either row or column). If both BandedRange.row_properties and BandedRange.column_properties are set, the fill colors are applied to cells according to the following rules: * header_color and footer_color take priority over band colors. * first_band_color takes priority over second_band_color. * row_properties takes priority over column_properties. For example, the first row color takes priority over the first column color, but the first column color takes priority over the second row color. Similarly, the row header takes priority over the column header in the top left cell, but the column header takes priority over the first row color if the row header is not set.
    BandingProperties columnProperties?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # Properties referring a single dimension (either row or column). If both BandedRange.row_properties and BandedRange.column_properties are set, the fill colors are applied to cells according to the following rules: * header_color and footer_color take priority over band colors. * first_band_color takes priority over second_band_color. * row_properties takes priority over column_properties. For example, the first row color takes priority over the first column color, but the first column color takes priority over the second row color. Similarly, the row header takes priority over the column header in the top left cell, but the column header takes priority over the first row color if the row header is not set.
    BandingProperties rowProperties?;
};

# Unmerges cells in the given range.
public type UnmergeCellsRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# A run of a text format. The format of this run continues until the start index of the next run. When updating, all fields must be set.
public type TextFormatRun record {
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat format?;
    # The character index where this run starts.
    int:Signed32 startIndex?;
};

# Merges all cells in the range.
public type MergeCellsRequest record {
    # How the cells should be merged.
    "MERGE_ALL"|"MERGE_COLUMNS"|"MERGE_ROWS" mergeType?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# Adds a new sheet. When a sheet is added at a given index, all subsequent sheets' indexes are incremented. To add an object sheet, use AddChartRequest instead and specify EmbeddedObjectPosition.sheetId or EmbeddedObjectPosition.newSheet.
public type AddSheetRequest record {
    # Properties of a sheet.
    SheetProperties properties?;
};

# Filter that describes what data should be selected or returned from a request.
public type DataFilter record {
    # Selects data that matches the specified A1 range.
    string a1Range?;
    # Selects DeveloperMetadata that matches all of the specified fields. For example, if only a metadata ID is specified this considers the DeveloperMetadata with that particular unique ID. If a metadata key is specified, this considers all developer metadata with that key. If a key, visibility, and location type are all specified, this considers all developer metadata with that key and visibility that are associated with a location of that type. In general, this selects all DeveloperMetadata that matches the intersection of all the specified fields; any field or combination of fields may be specified.
    DeveloperMetadataLookup developerMetadataLookup?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange gridRange?;
};

# The pivot table filter criteria associated with a specific source column offset.
public type PivotFilterSpec record {
    # The column offset of the source range.
    int:Signed32 columnOffsetIndex?;
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # Criteria for showing/hiding rows in a pivot table.
    PivotFilterCriteria filterCriteria?;
};

# Trims the whitespace (such as spaces, tabs, or new lines) in every cell in the specified range. This request removes all whitespace from the start and end of each cell's text, and reduces any subsequence of remaining whitespace characters to a single space. If the resulting trimmed text starts with a '+' or '=' character, the text remains as a string value and isn't interpreted as a formula.
public type TrimWhitespaceRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# A coordinate in a sheet. All indexes are zero-based.
public type GridCoordinate record {
    # The column index of the coordinate.
    int:Signed32 columnIndex?;
    # The row index of the coordinate.
    int:Signed32 rowIndex?;
    # The sheet this coordinate is on.
    int:Signed32 sheetId?;
};

# Update an embedded object's position (such as a moving or resizing a chart or image).
public type UpdateEmbeddedObjectPositionRequest record {
    # The fields of OverlayPosition that should be updated when setting a new position. Used only if newPosition.overlayPosition is set, in which case at least one field must be specified. The root `newPosition.overlayPosition` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # The position of an embedded object such as a chart.
    EmbeddedObjectPosition newPosition?;
    # The ID of the object to moved.
    int:Signed32 objectId?;
};

# A pair mapping a spreadsheet theme color type to the concrete color it represents.
public type ThemeColorPair record {
    # A color value.
    ColorStyle color?;
    # The type of the spreadsheet theme color.
    "THEME_COLOR_TYPE_UNSPECIFIED"|"TEXT"|"BACKGROUND"|"ACCENT1"|"ACCENT2"|"ACCENT3"|"ACCENT4"|"ACCENT5"|"ACCENT6"|"LINK" colorType?;
};

# A parameter in a data source's query. The parameter allows the user to pass in values from the spreadsheet into a query.
public type DataSourceParameter record {
    # Named parameter. Must be a legitimate identifier for the DataSource that supports it. For example, [BigQuery identifier](https://cloud.google.com/bigquery/docs/reference/standard-sql/lexical#identifiers).
    string name?;
    # ID of a NamedRange. Its size must be 1x1.
    string namedRangeId?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
};

# The options that define a "view window" for a chart (such as the visible values in an axis).
public type ChartAxisViewWindowOptions record {
    # The maximum numeric value to be shown in this view window. If unset, will automatically determine a maximum value that looks good for the data.
    decimal viewWindowMax?;
    # The minimum numeric value to be shown in this view window. If unset, will automatically determine a minimum value that looks good for the data.
    decimal viewWindowMin?;
    # The view window's mode.
    "DEFAULT_VIEW_WINDOW_MODE"|"VIEW_WINDOW_MODE_UNSUPPORTED"|"EXPLICIT"|"PRETTY" viewWindowMode?;
};

# The specification for a basic chart. See BasicChartType for the list of charts this supports.
public type BasicChartSpec record {
    # The axis on the chart.
    BasicChartAxis[] axis?;
    # The type of the chart.
    "BASIC_CHART_TYPE_UNSPECIFIED"|"BAR"|"LINE"|"AREA"|"COLUMN"|"SCATTER"|"COMBO"|"STEPPED_AREA" chartType?;
    # The behavior of tooltips and data highlighting when hovering on data and chart area.
    "BASIC_CHART_COMPARE_MODE_UNSPECIFIED"|"DATUM"|"CATEGORY" compareMode?;
    # The domain of data this is charting. Only a single domain is supported.
    BasicChartDomain[] domains?;
    # The number of rows or columns in the data that are "headers". If not set, Google Sheets will guess how many rows are headers based on the data. (Note that BasicChartAxis.title may override the axis title inferred from the header values.)
    int:Signed32 headerCount?;
    # If some values in a series are missing, gaps may appear in the chart (e.g, segments of lines in a line chart will be missing). To eliminate these gaps set this to true. Applies to Line, Area, and Combo charts.
    boolean interpolateNulls?;
    # The position of the chart legend.
    "BASIC_CHART_LEGEND_POSITION_UNSPECIFIED"|"BOTTOM_LEGEND"|"LEFT_LEGEND"|"RIGHT_LEGEND"|"TOP_LEGEND"|"NO_LEGEND" legendPosition?;
    # Gets whether all lines should be rendered smooth or straight by default. Applies to Line charts.
    boolean lineSmoothing?;
    # The data this chart is visualizing.
    BasicChartSeries[] series?;
    # The stacked type for charts that support vertical stacking. Applies to Area, Bar, Column, Combo, and Stepped Area charts.
    "BASIC_CHART_STACKED_TYPE_UNSPECIFIED"|"NOT_STACKED"|"STACKED"|"PERCENT_STACKED" stackedType?;
    # True to make the chart 3D. Applies to Bar and Column charts.
    boolean threeDimensional?;
    # Settings for one set of data labels. Data labels are annotations that appear next to a set of data, such as the points on a line chart, and provide additional information about what the data represents, such as a text representation of the value behind that point on the graph.
    DataLabel totalDataLabel?;
};

# The result of adding a new protected range.
public type AddProtectedRangeResponse record {
    # A protected range.
    ProtectedRange protectedRange?;
};

# Deletes the embedded object with the given ID.
public type DeleteEmbeddedObjectRequest record {
    # The ID of the embedded object to delete.
    int:Signed32 objectId?;
};

# A single grouping (either row or column) in a pivot table.
public type PivotGroup record {
    # An unique identifier that references a data source column.
    DataSourceColumnReference dataSourceColumnReference?;
    # The count limit on rows or columns in the pivot group.
    PivotGroupLimit groupLimit?;
    # An optional setting on a PivotGroup that defines buckets for the values in the source data column rather than breaking out each individual value. Only one PivotGroup with a group rule may be added for each column in the source data, though on any given column you may add both a PivotGroup that has a rule and a PivotGroup that does not.
    PivotGroupRule groupRule?;
    # The labels to use for the row/column groups which can be customized. For example, in the following pivot table, the row label is `Region` (which could be renamed to `State`) and the column label is `Product` (which could be renamed `Item`). Pivot tables created before December 2017 do not have header labels. If you'd like to add header labels to an existing pivot table, please delete the existing pivot table and then create a new pivot table with same parameters. +--------------+---------+-------+ | SUM of Units | Product | | | Region | Pen | Paper | +--------------+---------+-------+ | New York | 345 | 98 | | Oregon | 234 | 123 | | Tennessee | 531 | 415 | +--------------+---------+-------+ | Grand Total | 1110 | 636 | +--------------+---------+-------+
    string label?;
    # True if the headings in this pivot group should be repeated. This is only valid for row groupings and is ignored by columns. By default, we minimize repetition of headings by not showing higher level headings where they are the same. For example, even though the third row below corresponds to "Q1 Mar", "Q1" is not shown because it is redundant with previous rows. Setting repeat_headings to true would cause "Q1" to be repeated for "Feb" and "Mar". +--------------+ | Q1 | Jan | | | Feb | | | Mar | +--------+-----+ | Q1 Total | +--------------+
    boolean repeatHeadings?;
    # True if the pivot table should include the totals for this grouping.
    boolean showTotals?;
    # The order the values in this group should be sorted.
    "SORT_ORDER_UNSPECIFIED"|"ASCENDING"|"DESCENDING" sortOrder?;
    # The column offset of the source range that this grouping is based on. For example, if the source was `C10:E15`, a `sourceColumnOffset` of `0` means this group refers to column `C`, whereas the offset `1` would refer to column `D`.
    int:Signed32 sourceColumnOffset?;
    # Information about which values in a pivot group should be used for sorting.
    PivotGroupSortValueBucket valueBucket?;
    # Metadata about values in the grouping.
    PivotGroupValueMetadata[] valueMetadata?;
};

# A chart embedded in a sheet.
public type EmbeddedChart record {
    # A border along an embedded object.
    EmbeddedObjectBorder border?;
    # The ID of the chart.
    int:Signed32 chartId?;
    # The position of an embedded object such as a chart.
    EmbeddedObjectPosition position?;
    # The specifications of a chart.
    ChartSpec spec?;
};

# Updates a chart's specifications. (This does not move or resize a chart. To move or resize a chart, use UpdateEmbeddedObjectPositionRequest.)
public type UpdateChartSpecRequest record {
    # The ID of the chart to update.
    int:Signed32 chartId?;
    # The specifications of a chart.
    ChartSpec spec?;
};

# Updates all cells in a range with new data.
public type UpdateCellsRequest record {
    # The fields of CellData that should be updated. At least one field must be specified. The root is the CellData; 'row.values.' should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The data to write.
    RowData[] rows?;
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate 'start?;
};

# The result of duplicating a sheet.
public type DuplicateSheetResponse record {
    # Properties of a sheet.
    SheetProperties properties?;
};

# Developer metadata associated with a location or object in a spreadsheet. Developer metadata may be used to associate arbitrary data with various parts of a spreadsheet and will remain associated at those locations as they move around and the spreadsheet is edited. For example, if developer metadata is associated with row 5 and another row is then subsequently inserted above row 5, that original metadata will still be associated with the row it was first associated with (what is now row 6). If the associated object is deleted its metadata is deleted too.
public type DeveloperMetadata record {
    # A location where metadata may be associated in a spreadsheet.
    DeveloperMetadataLocation location?;
    # The spreadsheet-scoped unique ID that identifies the metadata. IDs may be specified when metadata is created, otherwise one will be randomly generated and assigned. Must be positive.
    int:Signed32 metadataId?;
    # The metadata key. There may be multiple metadata in a spreadsheet with the same key. Developer metadata must always have a key specified.
    string metadataKey?;
    # Data associated with the metadata's key.
    string metadataValue?;
    # The metadata visibility. Developer metadata must always have a visibility specified.
    "DEVELOPER_METADATA_VISIBILITY_UNSPECIFIED"|"DOCUMENT"|"PROJECT" visibility?;
};

# Inserts cells into a range, shifting the existing cells over or down.
public type InsertRangeRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The dimension which will be shifted when inserting cells. If ROWS, existing cells will be shifted down. If COLUMNS, existing cells will be shifted right.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" shiftDimension?;
};

# Represents spreadsheet theme
public type SpreadsheetTheme record {
    # Name of the primary font family.
    string primaryFontFamily?;
    # The spreadsheet theme color pairs. To update you must provide all theme color pairs.
    ThemeColorPair[] themeColors?;
};

# Splits a column of text into multiple columns, based on a delimiter in each cell.
public type TextToColumnsRequest record {
    # The delimiter to use. Used only if delimiterType is CUSTOM.
    string delimiter?;
    # The delimiter type to use.
    "DELIMITER_TYPE_UNSPECIFIED"|"COMMA"|"SEMICOLON"|"PERIOD"|"SPACE"|"CUSTOM"|"AUTODETECT" delimiterType?;
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange 'source?;
};

# Represents a time of day. The date and time zone are either not significant or are specified elsewhere. An API may choose to allow leap seconds. Related types are google.type.Date and `google.protobuf.Timestamp`.
public type TimeOfDay record {
    # Hours of day in 24 hour format. Should be from 0 to 23. An API may choose to allow the value "24:00:00" for scenarios like business closing time.
    int:Signed32 hours?;
    # Minutes of hour of day. Must be from 0 to 59.
    int:Signed32 minutes?;
    # Fractions of seconds in nanoseconds. Must be from 0 to 999,999,999.
    int:Signed32 nanos?;
    # Seconds of minutes of the time. Must normally be from 0 to 59. An API may allow the value 60 if it allows leap-seconds.
    int:Signed32 seconds?;
};

# Specifies a custom BigQuery query.
public type BigQueryQuerySpec record {
    # The raw query string.
    string rawQuery?;
};

# Updates properties of the supplied banded range.
public type UpdateBandingRequest record {
    # A banded (alternating colors) range in a sheet.
    BandedRange bandedRange?;
    # The fields that should be updated. At least one field must be specified. The root `bandedRange` is implied and should not be specified. A single `"*"` can be used as short-hand for listing every field.
    string fields?;
};

# Adds a data source. After the data source is added successfully, an associated DATA_SOURCE sheet is created and an execution is triggered to refresh the sheet to read data from the data source. The request requires an additional `bigquery.readonly` OAuth scope.
public type AddDataSourceRequest record {
    # Information about an external data source in the spreadsheet.
    DataSource dataSource?;
};

# Reference to a data source object.
public type DataSourceObjectReference record {
    # References to a data source chart.
    int:Signed32 chartId?;
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate dataSourceFormulaCell?;
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate dataSourcePivotTableAnchorCell?;
    # A coordinate in a sheet. All indexes are zero-based.
    GridCoordinate dataSourceTableAnchorCell?;
    # References to a DATA_SOURCE sheet.
    string sheetId?;
};

# A request to create developer metadata.
public type CreateDeveloperMetadataRequest record {
    # Developer metadata associated with a location or object in a spreadsheet. Developer metadata may be used to associate arbitrary data with various parts of a spreadsheet and will remain associated at those locations as they move around and the spreadsheet is edited. For example, if developer metadata is associated with row 5 and another row is then subsequently inserted above row 5, that original metadata will still be associated with the row it was first associated with (what is now row 6). If the associated object is deleted its metadata is deleted too.
    DeveloperMetadata developerMetadata?;
};

# Deletes a range of cells, shifting other cells into the deleted area.
public type DeleteRangeRequest record {
    # A range on a sheet. All indexes are zero-based. Indexes are half open, i.e. the start index is inclusive and the end index is exclusive -- [start_index, end_index). Missing indexes indicate the range is unbounded on that side. For example, if `"Sheet1"` is sheet ID 123456, then: `Sheet1!A1:A1 == sheet_id: 123456, start_row_index: 0, end_row_index: 1, start_column_index: 0, end_column_index: 1` `Sheet1!A3:B4 == sheet_id: 123456, start_row_index: 2, end_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1!A:B == sheet_id: 123456, start_column_index: 0, end_column_index: 2` `Sheet1!A5:B == sheet_id: 123456, start_row_index: 4, start_column_index: 0, end_column_index: 2` `Sheet1 == sheet_id: 123456` The start index must always be less than or equal to the end index. If the start index equals the end index, then the range is empty. Empty ranges are typically not meaningful and are usually rendered in the UI as `#REF!`.
    GridRange range?;
    # The dimension from which deleted cells will be replaced with. If ROWS, existing cells will be shifted upward to replace the deleted cells. If COLUMNS, existing cells will be shifted left to replace the deleted cells.
    "DIMENSION_UNSPECIFIED"|"ROWS"|"COLUMNS" shiftDimension?;
};

# A waterfall chart.
public type WaterfallChartSpec record {
    # Properties that describe the style of a line.
    LineStyle connectorLineStyle?;
    # The domain of a waterfall chart.
    WaterfallChartDomain domain?;
    # True to interpret the first value as a total.
    boolean firstValueIsTotal?;
    # True to hide connector lines between columns.
    boolean hideConnectorLines?;
    # The data this waterfall chart is visualizing.
    WaterfallChartSeries[] series?;
    # The stacked type.
    "WATERFALL_STACKED_TYPE_UNSPECIFIED"|"STACKED"|"SEQUENTIAL" stackedType?;
    # Settings for one set of data labels. Data labels are annotations that appear next to a set of data, such as the points on a line chart, and provide additional information about what the data represents, such as a text representation of the value behind that point on the graph.
    DataLabel totalDataLabel?;
};

# The response when clearing a range of values selected with DataFilters in a spreadsheet.
public type BatchClearValuesByDataFilterResponse record {
    # The ranges that were cleared, in [A1 notation](/sheets/api/guides/concepts#cell). If the requests are for an unbounded range or a ranger larger than the bounds of the sheet, this is the actual ranges that were cleared, bounded to the sheet's limits.
    string[] clearedRanges?;
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
};

# A single response from an update.
public type Response record {
    # The result of adding a banded range.
    AddBandingResponse addBanding?;
    # The result of adding a chart to a spreadsheet.
    AddChartResponse addChart?;
    # The result of adding a data source.
    AddDataSourceResponse addDataSource?;
    # The result of adding a group.
    AddDimensionGroupResponse addDimensionGroup?;
    # The result of adding a filter view.
    AddFilterViewResponse addFilterView?;
    # The result of adding a named range.
    AddNamedRangeResponse addNamedRange?;
    # The result of adding a new protected range.
    AddProtectedRangeResponse addProtectedRange?;
    # The result of adding a sheet.
    AddSheetResponse addSheet?;
    # The result of adding a slicer to a spreadsheet.
    AddSlicerResponse addSlicer?;
    # The response from creating developer metadata.
    CreateDeveloperMetadataResponse createDeveloperMetadata?;
    # The result of deleting a conditional format rule.
    DeleteConditionalFormatRuleResponse deleteConditionalFormatRule?;
    # The response from deleting developer metadata.
    DeleteDeveloperMetadataResponse deleteDeveloperMetadata?;
    # The result of deleting a group.
    DeleteDimensionGroupResponse deleteDimensionGroup?;
    # The result of removing duplicates in a range.
    DeleteDuplicatesResponse deleteDuplicates?;
    # The result of a filter view being duplicated.
    DuplicateFilterViewResponse duplicateFilterView?;
    # The result of duplicating a sheet.
    DuplicateSheetResponse duplicateSheet?;
    # The result of the find/replace.
    FindReplaceResponse findReplace?;
    # The response from refreshing one or multiple data source objects.
    RefreshDataSourceResponse refreshDataSource?;
    # The result of trimming whitespace in cells.
    TrimWhitespaceResponse trimWhitespace?;
    # The result of updating a conditional format rule.
    UpdateConditionalFormatRuleResponse updateConditionalFormatRule?;
    # The response from updating data source.
    UpdateDataSourceResponse updateDataSource?;
    # The response from updating developer metadata.
    UpdateDeveloperMetadataResponse updateDeveloperMetadata?;
    # The result of updating an embedded object's position.
    UpdateEmbeddedObjectPositionResponse updateEmbeddedObjectPosition?;
};

# Updates a slicer's specifications. (This does not move or resize a slicer. To move or resize a slicer use UpdateEmbeddedObjectPositionRequest.
public type UpdateSlicerSpecRequest record {
    # The fields that should be updated. At least one field must be specified. The root `SlicerSpec` is implied and should not be specified. A single "*"` can be used as short-hand for listing every field.
    string fields?;
    # The id of the slicer to update.
    int:Signed32 slicerId?;
    # The specifications of a slicer.
    SlicerSpec spec?;
};

# A custom subtotal column for a waterfall chart series.
public type WaterfallChartCustomSubtotal record {
    # True if the data point at subtotal_index is the subtotal. If false, the subtotal will be computed and appear after the data point.
    boolean dataIsSubtotal?;
    # A label for the subtotal column.
    string label?;
    # The 0-based index of a data point within the series. If data_is_subtotal is true, the data point at this index is the subtotal. Otherwise, the subtotal appears after the data point with this index. A series can have multiple subtotals at arbitrary indices, but subtotals do not affect the indices of the data points. For example, if a series has three data points, their indices will always be 0, 1, and 2, regardless of how many subtotals exist on the series or what data points they are associated with.
    int:Signed32 subtotalIndex?;
};

# Position settings for text.
public type TextPosition record {
    # Horizontal alignment setting for the piece of text.
    "HORIZONTAL_ALIGN_UNSPECIFIED"|"LEFT"|"CENTER"|"RIGHT" horizontalAlignment?;
};

# A weekly schedule for data to refresh on specific days in a given time interval.
public type DataSourceRefreshWeeklySchedule record {
    # Days of the week to refresh. At least one day must be specified.
    ("DAY_OF_WEEK_UNSPECIFIED"|"MONDAY"|"TUESDAY"|"WEDNESDAY"|"THURSDAY"|"FRIDAY"|"SATURDAY"|"SUNDAY")[] daysOfWeek?;
    # Represents a time of day. The date and time zone are either not significant or are specified elsewhere. An API may choose to allow leap seconds. Related types are google.type.Date and `google.protobuf.Timestamp`.
    TimeOfDay startTime?;
};

# Inserts rows or columns in a sheet at a particular index.
public type InsertDimensionRequest record {
    # Whether dimension properties should be extended from the dimensions before or after the newly inserted dimensions. True to inherit from the dimensions before (in which case the start index must be greater than 0), and false to inherit from the dimensions after. For example, if row index 0 has red background and row index 1 has a green background, then inserting 2 rows at index 1 can inherit either the green or red background. If `inheritFromBefore` is true, the two new rows will be red (because the row before the insertion point was red), whereas if `inheritFromBefore` is false, the two new rows will be green (because the row after the insertion point was green).
    boolean inheritFromBefore?;
    # A range along a single dimension on a sheet. All indexes are zero-based. Indexes are half open: the start index is inclusive and the end index is exclusive. Missing indexes indicate the range is unbounded on that side.
    DimensionRange range?;
};

# The result of adding a chart to a spreadsheet.
public type AddChartResponse record {
    # A chart embedded in a sheet.
    EmbeddedChart chart?;
};

# The request for updating more than one range of values in a spreadsheet.
public type BatchUpdateValuesRequest record {
    # The new values to apply to the spreadsheet.
    GsheetValueRange[] data?;
    # Determines if the update response should include the values of the cells that were updated. By default, responses do not include the updated values. The `updatedData` field within each of the BatchUpdateValuesResponse.responses contains the updated values. If the range to write was larger than the range actually written, the response includes all values in the requested range (excluding trailing empty rows and columns).
    boolean includeValuesInResponse?;
    # Determines how dates, times, and durations in the response should be rendered. This is ignored if response_value_render_option is FORMATTED_VALUE. The default dateTime render option is SERIAL_NUMBER.
    "SERIAL_NUMBER"|"FORMATTED_STRING" responseDateTimeRenderOption?;
    # Determines how values in the response should be rendered. The default render option is FORMATTED_VALUE.
    "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA" responseValueRenderOption?;
    # How the input data should be interpreted.
    "INPUT_VALUE_OPTION_UNSPECIFIED"|"RAW"|"USER_ENTERED" valueInputOption?;
};

# Adds a filter view.
public type AddFilterViewRequest record {
    # A filter view.
    FilterView filter?;
};

# A sheet in a spreadsheet.
public type Sheet record {
    # The banded (alternating colors) ranges on this sheet.
    BandedRange[] bandedRanges?;
    # The default filter associated with a sheet.
    BasicFilter basicFilter?;
    # The specifications of every chart on this sheet.
    EmbeddedChart[] charts?;
    # All column groups on this sheet, ordered by increasing range start index, then by group depth.
    DimensionGroup[] columnGroups?;
    # The conditional format rules in this sheet.
    ConditionalFormatRule[] conditionalFormats?;
    # Data in the grid, if this is a grid sheet. The number of GridData objects returned is dependent on the number of ranges requested on this sheet. For example, if this is representing `Sheet1`, and the spreadsheet was requested with ranges `Sheet1!A1:C10` and `Sheet1!D15:E20`, then the first GridData will have a startRow/startColumn of `0`, while the second one will have `startRow 14` (zero-based row 15), and `startColumn 3` (zero-based column D). For a DATA_SOURCE sheet, you can not request a specific range, the GridData contains all the values.
    GridData[] data?;
    # The developer metadata associated with a sheet.
    DeveloperMetadata[] developerMetadata?;
    # The filter views in this sheet.
    FilterView[] filterViews?;
    # The ranges that are merged together.
    GridRange[] merges?;
    # Properties of a sheet.
    SheetProperties properties?;
    # The protected ranges in this sheet.
    ProtectedRange[] protectedRanges?;
    # All row groups on this sheet, ordered by increasing range start index, then by group depth.
    DimensionGroup[] rowGroups?;
    # The slicers on this sheet.
    Slicer[] slicers?;
};

# The response when updating a range of values in a spreadsheet.
public type UpdateValuesResponse record {
    # The spreadsheet the updates were applied to.
    string spreadsheetId?;
    # The number of cells updated.
    int:Signed32 updatedCells?;
    # The number of columns where at least one cell in the column was updated.
    int:Signed32 updatedColumns?;
    # Data within a range of the spreadsheet.
    GsheetValueRange updatedData?;
    # The range (in A1 notation) that updates were applied to.
    string updatedRange?;
    # The number of rows where at least one cell in the row was updated.
    int:Signed32 updatedRows?;
};

# Settings for one set of data labels. Data labels are annotations that appear next to a set of data, such as the points on a line chart, and provide additional information about what the data represents, such as a text representation of the value behind that point on the graph.
public type DataLabel record {
    # The data included in a domain or series.
    ChartData customLabelData?;
    # The placement of the data label relative to the labeled data.
    "DATA_LABEL_PLACEMENT_UNSPECIFIED"|"CENTER"|"LEFT"|"RIGHT"|"ABOVE"|"BELOW"|"INSIDE_END"|"INSIDE_BASE"|"OUTSIDE_END" placement?;
    # The format of a run of text in a cell. Absent values indicate that the field isn't specified.
    TextFormat textFormat?;
    # The type of the data label.
    "DATA_LABEL_TYPE_UNSPECIFIED"|"NONE"|"DATA"|"CUSTOM" 'type?;
};

// New types
type RenderOptions "FORMATTED_VALUE"|"UNFORMATTED_VALUE"|"FORMULA";

public type ValueRange record {
    @display {label: "Row Number"}
    int rowPosition;
    @display {label: "Values"}
    (int|string|decimal|boolean|float)[] values;
    @display {label: "A1 Range"}
    A1Range a1Range;
};
// Types copied from all API
# File information
#
# + kind - Identifies what kind of resource is this. Value: the fixed string "drive#file".   
# + id - The Id of the file
# + name - The name of the file
# + mimeType - The MIME type of the file
@display {label: "File"}
public type File record {
    @display {label: "Kind"}
    string kind;
    @display {label: "Id"}
    string id;
    @display {label: "Name"}
    string name;
    @display {label: "Mime Type"}
    string mimeType;
};

# Single cell or a group of adjacent cells in a sheet.
#
# + a1Notation - The column letter followed by the row number.
# For example for a single cell "A1" refers to the intersection of column "A" with row "1",
# and for a range of cells "A1:D5" refers to the top left cell and the bottom right cell of a range
# + values - Values of the given range
@display {label: "Range"}
public type Range record {
    @display {label: "A1 Notation"}
    string a1Notation;
    @display {label: "Values"}
    (int|string|decimal)[][] values;
};

public type Column record {
    @display {label: "Column Letter"}
    string columnPosition;
    @display {label: "Values"}
    (int|string|decimal)[] values;
};

public type Row record {
    @display {label: "Row Number"}
    int rowPosition;
    @display {label: "Values"}
    (int|string|decimal)[] values;
};

public type Cell record {
    @display {label: "A1 Notation"}
    string a1Notation;
    @display {label: "Value"}
    (int|string|decimal) value;
};

public type A1Range record {
    @display {label: "Sheet Name"}
    string sheetName;
    @display {label: "Start Index"}
    string startIndex?;
    @display {label: "End Index"}
    string endIndex?;
};

public type FilesResponse record {
    @display {label: "Kind"}
    string kind;
    @display {label: "Next Page Token"}
    string nextPageToken?;
    @display {label: "Incomplete Search"}
    boolean incompleteSearch;
    @display {label: "Array of Files"}
    File[] files;
};

public enum Visibility {
    UNSPECIFIED_VISIBILITY = "DEVELOPER_METADATA_VISIBILITY_UNSPECIFIED",
    DOCUMENT = "DOCUMENT",
    PROJECT = "PROJECT"
};

public type Filter A1Range|DeveloperMetadataLookupFilter|GridRangeFilter;
public type GridRangeFilter record {
    @display {label: "Worksheet ID"}
    int sheetId;
    @display {label: "Starting Row Index"}
    int startRowIndex?;
    @display {label: "Ending Row Index"}
    int endRowIndex?;
    @display {label: "Starting Column Index"}
    int startColumnIndex?;
    @display {label: "Ending Column Index"}
    int endColumnIndex?;
};
public type DeveloperMetadataLookupFilter record {
    @display {label: "Location Type"}
    LocationType locationType;
    @display {label: "Location matching strategy"}
    LocationMatchingStrategy locationMatchingStrategy?;
    @display {label: "Metadata Id"}
    int metadataId?;
    @display {label: "Metadata Key"}
    string metadataKey?;
    @display {label: "Metadata Value"}
    string metadataValue;
    @display {label: "Metadata Visibility"}
    Visibility visibility?;
    @display {label: "Metadata Location"}
    MetadataLocation metadataLocation?;
};
public type MetadataLocation record {
    @display {label: "Location Type"}
    LocationType locationType;
    @display {label: "Spreadsheet"}
    boolean spreadsheet;
    @display {label: "Worksheet ID"}
    int sheetId;
    @display {label: "Dimension Range"}
    DimensionRange dimensionRange;
};
public enum LocationType {
    UNSPECIFIED_LOCATION = "DEVELOPER_METADATA_LOCATION_TYPE_UNSPECIFIED",
    COLUMN = "COLUMN",
    SPREADSHEET = "SPREADSHEET",
    SHEET = "SHEET",
    ROW = "ROW"
};
public enum LocationMatchingStrategy {
    UNSPECIFIED_STRATEGY = "DEVELOPER_METADATA_LOCATION_MATCHING_STRATEGY_UNSPECIFIED",
    EXACT_LOCATION = "EXACT_LOCATION",
    INTERSECTING_LOCATION = "INTERSECTING_LOCATION"
};

// Conversion functoins

isolated function intoCell(BatchGetValuesResponse res) returns Cell {
    GsheetValueRange[]? valueRanges = res.valueRanges;
    if valueRanges == () {
        panic error("empty value range");
    }
    if valueRanges.length() != 1 {
        panic error("invalid value range");
    }
    anydata[][] values = <anydata[][]>valueRanges[0].values;
    if values.length() != 1 || values[0].length() != 1 {
        panic error("unexpected shape");
    }
    int|decimal|string value = checkpanic values[0][0].cloneWithType();
    string a1Notation = <string>valueRanges[0].range;
    return {
        a1Notation,
        value
    };
}

isolated function intoRow(Range range) returns Row {
    (int|string|decimal)[][] resVal = range.values;
    if resVal.length() != 1 {
        panic error("invalid row");
    }
    (int|string|decimal)[] values = resVal[0];
    var { startIndex } = intoA1Notation(range.a1Notation);
    if startIndex == () {
        panic error("unexpected a1Notation:"+ range.a1Notation);
    }
    int rowPosition = <int>startIndex[1];
    return {
        rowPosition,
        values
    };
}

isolated function intoColumn(Range range) returns Column {
    (int|string|decimal)[][] resVal = range.values;
    (int|string|decimal)[] values = [];
    foreach var row in resVal {
        if row.length() != 1 {
            panic error("invalid column");
        }
        values.push(row[0]);
    }
    var { startIndex } = intoA1Notation(range.a1Notation);
    if startIndex == () {
        panic error("unexpected a1Notation:"+ range.a1Notation);
    }
    string columnPosition = <string>startIndex[0];
    return {
        columnPosition,
        values
    };
}

isolated function intoRange(GsheetValueRange valueRange) returns Range {
    // NOTE: casting don't work here (probably JBUG)
    return {values: checkpanic valueRange.values.cloneWithType(), a1Notation: <string>valueRange.range};
}

isolated function inToGsheetValueRange(Range range) returns GsheetValueRange {
    return {range: range.a1Notation, values: range.values};
}

isolated function intoDataFilter(Filter filter) returns DataFilter {
    if filter is A1Range {
        return {a1Range: checkpanic getA1RangeString(filter)};
    } else if filter is GridRangeFilter {
        return {gridRange: checkpanic filter.cloneWithType()};
    } else {
        return {developerMetadataLookup: checkpanic filter.cloneWithType()};
    }
}

isolated function tryIntoValueRange(GsheetValueRange valueRange) returns ValueRange? {
    if valueRange.values == () || valueRange.majorDimension == () || valueRange.range == () {
        return ();
    }
    return intoValueRange(valueRange);
}

isolated function intoValueRange(GsheetValueRange valueRange) returns ValueRange {
    anydata[][] tmpValues = <anydata[][]>valueRange.values;
    string range = <string>valueRange.range;
    A1Range a1Range = intoA1Range(range);
    var { startIndex } = intoA1Notation(range);
    if startIndex == () {
        panic error("invalid range"+ range);
    }
    int rowPosition = <int>startIndex[1];
    (int|string|decimal|boolean|float)[] values = checkpanic tmpValues[0].cloneWithType();
    return { rowPosition, values, a1Range };
}

type Index [string?, int?];

type A1Notation record {|
    string? sheetName;
    Index? startIndex;
    Index? endIndex;
|};

isolated function intoA1Range(string range) returns A1Range {
    var {sheetName, startIndex, endIndex} = intoA1Notation(range);
    string? sIndex = startIndex != () ? intoString(startIndex) : ();
    string? eIndex = endIndex != () ? intoString(endIndex) : ();
    if sheetName == () {
        panic error("sheet name is required");
    }
    return {
        sheetName,
        startIndex: sIndex,
        endIndex: eIndex
    };
}

isolated function intoString(Index index) returns string {
    var [column, row] = index;
    string rowString = row == () ? "" : row.toString();
    string columnString = column ?: "";
    return columnString + rowString;
}

isolated function intoA1Notation(string notation) returns A1Notation {
    string:RegExp a1Patter = re `(.*!)?([A-Z]*[0-9]*):?([A-Z]*[0-9]*)`;
    regexp:Groups? groups = a1Patter.findGroups(notation);
    if groups == () {
        panic error("invalid A1 notation: " + notation);
    }
    regexp:Span? nameSpan = groups[1];
    regexp:Span? startColumnSpan = groups[2];
    regexp:Span? endColumnSpan = groups[3];
    string? sheetName = nameSpan != () ? nameSpan.substring(): ();
    Index? startIndex = startColumnSpan != () ? parseIndex(startColumnSpan.substring()) : ();
    Index? endIndex = endColumnSpan != () ? parseIndex(endColumnSpan.substring()) : ();
    return {
        sheetName,
        startIndex,
        endIndex
    };
}

isolated function parseIndex(string index) returns Index? {
    if index.length() == 0 {
        return ();
    }
    string:RegExp indexPattern = re `([A-Z]*)([0-9]*)`;
    regexp:Groups? groups = indexPattern.findGroups(index);
    if groups == () {
        return ();
    }
    regexp:Span? columnSpan = groups[1];
    regexp:Span? rowSpan = groups[2];
    string? column = columnSpan != () ? columnSpan.substring() : ();
    // if rowSpan != () && rowSpan.startIndex == rowSpan.endIndex {
    //     panic error("invalid A1 notation: " + index);
    // }
    int? row = rowSpan != () ? checkpanic int:fromString(rowSpan.substring()) : ();
    return [column, row];
}

// -- copied from original
isolated function getA1RangeString(A1Range a1Range) returns string|error {
    string filter = a1Range.sheetName;
    if a1Range.startIndex == () && a1Range.endIndex != () {
        return error("Error: The provided A1 range is not supported. ");
    }
    if a1Range.startIndex != () {
        filter = string `${filter}!${<string>a1Range.startIndex}`;
    }
    if a1Range.endIndex != () {
        filter = string `${filter}:${<string>a1Range.endIndex}`;
    }
    return filter;
}
