package local.vo;

public class CommentReport extends Comment{
	private int commentReportId;
	private int commentId;
	private int createdBy;
	private String createdIp;
	private String createdAt;
	private String reason;
	private String status;
	
	
	
	
	public int getCommentReportId() {
		return commentReportId;
	}
	public void setCommentReportId(int commentReportId) {
		this.commentReportId = commentReportId;
	}
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
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