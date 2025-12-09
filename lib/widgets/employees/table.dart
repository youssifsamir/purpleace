// packages
import 'package:flutter/material.dart';

// widgets
import './datasearch.dart';

class CustomDataTable<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumnDefinition<T>> columns;
  final String? title;
  final double? rowHeight;
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;
  final Color? headerColor;
  final Color? rowColor;
  final EdgeInsetsGeometry? padding;
  final bool showBorders;
  final BorderRadius? borderRadius;
  final double? columnSpacing;

  const CustomDataTable({
    super.key,
    required this.data,
    required this.columns,
    this.title,
    this.rowHeight,
    this.headerStyle,
    this.cellStyle,
    this.headerColor,
    this.rowColor,
    this.padding,
    this.showBorders = true,
    this.borderRadius,
    this.columnSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController(); // controller

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: padding ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flexible ensures it fits in screen without overflow
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border:
                              showBorders
                                  ? TableBorder.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  )
                                  : TableBorder.symmetric(),
                          columnWidths: {
                            for (int i = 0; i < columns.length; i++)
                              i: const IntrinsicColumnWidth(),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(
                                color: headerColor ?? Colors.grey[100],
                              ),
                              children:
                                  columns
                                      .map(
                                        (col) => Padding(
                                          padding: EdgeInsets.all(
                                            columnSpacing ?? 12,
                                          ),
                                          child: Text(
                                            col.label,
                                            style:
                                                headerStyle ??
                                                const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),

                            // Data Rows
                            ...data.map((item) {
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: rowColor ?? Colors.white,
                                ),
                                children:
                                    columns.map((col) {
                                      final cellValue = col.cellBuilder(item);
                                      return Padding(
                                        padding: EdgeInsets.all(
                                          columnSpacing ?? 12,
                                        ),
                                        child:
                                            cellValue is Widget
                                                ? cellValue
                                                : Text(
                                                  cellValue.toString(),
                                                  style:
                                                      cellStyle ??
                                                      const TextStyle(
                                                        color: Colors.black87,
                                                      ),
                                                ),
                                      );
                                    }).toList(),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
