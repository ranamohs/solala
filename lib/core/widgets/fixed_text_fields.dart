import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PrimaryTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? isPasswordField;
  final String? Function(String? val)? validate;
  final TextInputType? type;
  final void Function(String)? onSubmit;
  final String? Function(String val)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool? readOnly;
  final String? svgPath;
  final void Function()? onTap;
  final TextInputType? textInputType;
  final String? Function(String?)? validation;
  final bool? enabled;

  const PrimaryTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText,
    this.isPasswordField,
    this.suffixIcon,
    this.validate,
    this.type,
    this.onSubmit,
    this.onChanged,
    this.prefixIcon,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.svgPath,
    this.textInputType,
    this.validation,
    this.enabled,
  });

  @override
  State<PrimaryTextFormField> createState() => _PrimaryTextFormFieldState();
}

class _PrimaryTextFormFieldState extends State<PrimaryTextFormField> {
  bool _isObscure = true;
  bool _hasUserInteracted = false; // لتتبع إذا كان المستخدم تفاعل مع الحقل
  String? _currentErrorText; // لتخزين نص الخطأ الحالي

  @override
  Widget build(BuildContext context) {
    final bool showPasswordToggle = widget.isPasswordField == true;
    final bool isObscure = widget.obscureText ?? (showPasswordToggle ? _isObscure : false);

    final int effectiveMaxLines = isObscure ? 1 : (widget.maxLines ?? 1);
    final int effectiveMinLines = isObscure ? 1 : (widget.minLines ?? 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scaleY: 0.9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGreyColor),
              color: AppColors.pureWhiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              enabled: widget.enabled,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorRadius: const Radius.circular(16),
              cursorHeight: 28,
              cursorWidth: 1.5,
              minLines: effectiveMinLines,
              maxLines: effectiveMaxLines,
              maxLength: widget.maxLength,
              buildCounter: (
                  context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) =>
              const SizedBox.shrink(),
              obscureText: isObscure,
              onFieldSubmitted: widget.onSubmit,
              onChanged: (value) {
                // تحديث حالة التفاعل عند كل تغيير
                setState(() {
                  _hasUserInteracted = true;
                  _currentErrorText = _getErrorText(value);
                });
                widget.onChanged?.call(value);
              },
              onTapOutside: (_) {
                // عند الضغط خارج الحقل، نتحقق من الصحة
                setState(() {
                  _hasUserInteracted = true;
                  _currentErrorText = _getErrorText(widget.controller?.text);
                });
              },
              keyboardType: widget.textInputType ?? widget.type,
              style: AppStyles.styleMedium18(context).copyWith(color: AppColors.pureBlackColor),
              validator: widget.validation ?? widget.validate,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: widget.svgPath != null
                    ? Transform.scale(
                  scale: 0.6,
                  child: SvgPicture.asset(
                    widget.svgPath!,
                    colorFilter: ColorFilter.mode(AppColors.lightGreyColor, BlendMode.srcIn),
                  ),
                )
                    : widget.prefixIcon,
                suffixIcon: showPasswordToggle
                    ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.lightGreyColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
                    : widget.suffixIcon,
                labelText: widget.labelText,
                labelStyle: AppStyles.styleRegular16(context).copyWith(color: AppColors.offGreyColor),
                hintText: widget.hintText,
                hintStyle: AppStyles.styleRegular14(context),
                // إزالة عرض الخطأ من داخل الحقل
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: const TextStyle(height: 0, fontSize: 0),
              ),
              controller: widget.controller,
            ),
          ),
        ),
        // عرض رسالة الخطأ تحت الحقل فقط إذا كان هناك خطأ والمستخدم تفاعل مع الحقل
        if (_hasUserInteracted && _currentErrorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              _currentErrorText!,
              style: AppStyles.styleRegular12(context).copyWith(
                color: AppColors.offRedColor,
              ),
            ),
          ),
      ],
    );
  }

  String? _getErrorText(String? value) {
    final validator = widget.validation ?? widget.validate;
    if (validator != null) {
      return validator(value);
    }
    return null;
  }
}
class SecondaryTextFormField extends StatefulWidget {
  final String? fieldName;
  final String? labelText; // نستخدمها كـ Label فقط
  final TextEditingController? controller;
  final bool? obscureText;
  final bool? isPasswordField;
  final String? Function(String? val)? validate;
  final TextInputType? type;
  final void Function(String)? onSubmit;
  final String? Function(String val)? onChanged;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool? readOnly;
  final void Function()? onTap;
  final TextInputType? textInputType;
  final String? Function(String?)? validation;

  const SecondaryTextFormField({
    super.key,
    this.fieldName,
    this.labelText,
    this.controller,
    this.obscureText,
    this.isPasswordField,
    this.suffixIcon,
    this.validate,
    this.type,
    this.onSubmit,
    this.onChanged,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.textInputType,
    this.validation,
  });

  @override
  State<SecondaryTextFormField> createState() => _SecondaryTextFormFieldState();
}

class _SecondaryTextFormFieldState extends State<SecondaryTextFormField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final bool isPassword = widget.isPasswordField == true;
    final bool hide = widget.obscureText ?? (isPassword ? _isObscure : false);

    final String label = widget.labelText ?? widget.fieldName ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LABEL OUTSIDE LIKE THE DESIGN
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppStyles.styleMedium14(context).copyWith(color: AppColors.white)
          ),
          const SizedBox(height: 6),
        ],

        /// FIELD
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.40),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: hide,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.textInputType ?? widget.type,
            maxLength: widget.maxLength,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmit,
            validator: widget.validation ?? widget.validate,
            style: AppStyles.styleRegular16(context).copyWith(color: AppColors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              hintText: null,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  hide ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(.7),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

