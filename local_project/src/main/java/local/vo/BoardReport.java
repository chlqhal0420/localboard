package local.vo;

public class BoardReport {
	private int boardReportId;
	private int boardId;
	private int createdBy;
	private String createdIp;
	private String createdAt;
	private String modifiedAt;
	private int modifiedBy;
	private String modifiedIp;
	private String reason;
	private String status;
	private char boardCode;		//신고 게시글 구분코드
	private int boardNo;		//신고 게시글 번호
	
	
	
	
	public int getBoardReportId() {
		return boardReportId;
	}
	public void setBoardReportId(int boardReportId) {
		this.boardReportId = boardReportId;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
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
	public String getModifiedAt() {
		return modifiedAt;
	}
	public void setModifiedAt(String modifiedAt) {
		this.modifiedAt = modifiedAt;
	}
	public int getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedIp() {
		return modifiedIp;
	}
	public void setModifiedIp(String modifiedIp) {
		this.modifiedIp = modifiedIp;
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
	public char getBoardCode() {
		return boardCode;
	}
	public void setBoardCode(char boardCode) {
		this.boardCode = boardCode;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	
	
	
	
	
	
	
}