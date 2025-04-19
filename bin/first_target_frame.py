import cv2
import numpy as np

def is_black(frame_segment, frame_index):
    threshold = 10
    brightness = np.max(frame_segment)
    #print(f"Frame {frame_index}: Brightness = {brightness}")
    return brightness < threshold

def is_red(frame_segment, frame_index):
    threshold = 192
    redness = np.mean(frame_segment[:,:,2])
    #print(f"Frame {frame_index}: Redness = {redness}")
    return redness > threshold

def save_frame(video_path, img_fname, frame_idx):
    cap = cv2.VideoCapture(video_path)
    cap.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
    _, frame = cap.read()
    cv2.imwrite(img_fname, frame)

def find_target_frame(video_path, img_path, is_target_frame, starting_frame=0):
    cap = cv2.VideoCapture(video_path)
    #cap.set(cv2.CAP_PROP_POS_FRAMES, starting_frame)
    #frame_index = starting_frame
    frame_index = 1
    found = False

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        if frame_index < starting_frame:
            frame_index += 1
            continue

        mid_y, mid_x = frame.shape[0] // 2, frame.shape[1] // 2
        sw = 2 * 100
        square = frame[mid_y-sw:mid_y+sw, mid_x-sw:mid_x+sw]
        if is_target_frame(square, frame_index):
            found = True
            cv2.imwrite(img_path, frame)
            print(f"Target frame found at index: {frame_index} and saved as '{img_path}'")
            break

        frame_index += 1

    cap.release()
    if not found:
        print(f"No frame found with starting frame {starting_frame}.")
        return None
    return frame_index

def get_duration_between_frames(video_path, start_frame, end_frame):
    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    cap.release()

    if fps == 0:
        raise ValueError("Could not retrieve FPS. Is the video file valid?")

    total_seconds = (end_frame - start_frame) / fps
    minutes = int(total_seconds // 60)
    seconds = total_seconds % 60
    print(f"Time between frame {start_frame} and {end_frame}: {minutes:02d}:{seconds:06.3f}")

save_frame("temp.mp4","frame.jpg",14000)
start_frame = find_target_frame("temp_frames.mp4", "start.jpg", is_black, starting_frame=240)
end_frame = find_target_frame("temp.mp4", "end.jpg", is_red, starting_frame=14000)

get_duration_between_frames("temp.mp4", start_frame, end_frame)
