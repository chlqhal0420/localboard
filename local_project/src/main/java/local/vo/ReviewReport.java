package local.vo;

public class ReviewReport {
	private int reviewReportId;
	private int reviewId;
	private int createdBy;
	private String createdIp;
	private String createdAt;
	private String reason;
	private String status;
	private String content; // 후기 내용
	private String title; // 동네업체 제목
	private int lbId; // 동네업체 게시글 번호
	
	
	
	
	public int getLbId() {
		return lbId;
	}
	public void setLbId(int lbId) {
		this.lbId = lbId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getReviewReportId() {
		return reviewReportId;
	}
	public void setReviewReportId(int reviewReportId) {
		this.reviewReportId = reviewReportId;
	}
	public int getReviewId() {
		return reviewId;
	}
	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedIp() {
		return createdIp;
	}
	public void setCreatedIp(String createdIp) {
		this.createdIp = createdIp;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
	
	
}
