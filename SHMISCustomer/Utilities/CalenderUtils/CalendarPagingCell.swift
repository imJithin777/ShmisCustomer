import Parchment
import UIKit

class CalendarPagingCell: PagingCell {
    private var options: PagingOptions?

    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel(frame: .zero)
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        return dateLabel
    }()

    lazy var weekdayLabel: UILabel = {
        let weekdayLabel = UILabel(frame: .zero)
        weekdayLabel.font = UIFont.systemFont(ofSize: 12)
        return weekdayLabel
    }()
    
    lazy var monthLabel: UILabel = {
        let monthLabel = UILabel(frame: .zero)
        monthLabel.font = UIFont.systemFont(ofSize: 12)
        return monthLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        monthLabel.frame = CGRect(
            x: 0,
            y: insets.top,
            width: contentView.bounds.width,
            height: 20
        )

        dateLabel.frame = CGRect(
            x: 0,
            y: monthLabel.frame.origin.y + monthLabel.frame.size.height + 5,
            width: contentView.bounds.width,
            height: 20
        )

        weekdayLabel.frame = CGRect(
            x: 0,
            y: dateLabel.frame.origin.y + dateLabel.frame.size.height + 5,
            width: contentView.bounds.width,
            height: 20
        )
    }

    fileprivate func configure() {
        weekdayLabel.backgroundColor = .white
        weekdayLabel.textAlignment = .center
        dateLabel.backgroundColor = .white
        dateLabel.textAlignment = .center
        monthLabel.backgroundColor = .white
        monthLabel.textAlignment = .center

        addSubview(monthLabel)
        addSubview(weekdayLabel)
        addSubview(dateLabel)
    }

    fileprivate func updateSelectedState(selected: Bool) {
        guard let options = options else { return }
        if selected {
            dateLabel.textColor = options.selectedTextColor
            weekdayLabel.textColor = options.selectedTextColor
            monthLabel.textColor = options.selectedTextColor
        } else {
            dateLabel.textColor = options.textColor
            weekdayLabel.textColor = options.textColor
            monthLabel.textColor = options.textColor
        }
    }

    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        self.options = options
        let calendarItem = pagingItem as! CalendarItem
        dateLabel.text = calendarItem.dateText
        weekdayLabel.text = calendarItem.weekdayText
        monthLabel.text = calendarItem.monthlyText

        updateSelectedState(selected: selected)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let options = options else { return }

        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            dateLabel.textColor = UIColor.interpolate(
                from: options.textColor,
                to: options.selectedTextColor,
                with: attributes.progress
            )

            weekdayLabel.textColor = UIColor.interpolate(
                from: options.textColor,
                to: options.selectedTextColor,
                with: attributes.progress
            )
            
            monthLabel.textColor = UIColor.interpolate(
                from: options.textColor,
                to: options.selectedTextColor,
                with: attributes.progress
            )
        }
    }
}
